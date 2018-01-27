# provider based on the go CLI thing
# https://github.com/hetznercloud/cli

Puppet::Type.type(:hetzner_server).provide(:api) do

  desc 'A REST API based provider to manage the hetzner cloud servers'

  commands :hcloud => 'hcloud'

  defaultfor :operatingsystem => :Archlinux

  def server_details
    begin
      output = hcloud(['server', 'describe', resource[:name]])
    rescue Puppet::ExecutionFailure => e
      Puppet.debug("#server_details had an error -> #{e.inspect}")
      return nil
    end
    output_splitted = output.split("\n")
    return nil if output_splitted.first =~ /server not found/
    output
  end

  def exists?
    server_details != nil
  end

  def create
    array = ['server', 'create', '--image', resource[:image], '--type', resource[:server_type], '--name', resource[:name]]
    if resource[:datacenter].to_s.length > 1
      Puppet.debug("datacenter property has the value #{resource[:datacenter]}")
      array << '--datacenter'
      array << resource[:datacenter]
    end

    if resource[:location].to_s.length > 1
      Puppet.debug("location property has the value #{resource[:datacenter]}")
      array << '--location'
      array << resource[:location]
    end

    if resource[:ssh_keys].count > 0
      Puppet.debug("ssh_keys property has the value #{resource[:ssh_keys]}")
      resource[:ssh_keys].each do |key|
        array << '--ssh-key'
        array << key
      end
    end

    Puppet.debug("create call is: #{array}")
    hcloud(array)
  end

  def destroy
    hcloud('server', 'delete', resource[:name])
  end

  def stop
    hcloud('server', 'poweroff', resource[:name])
  end

  def self.instances
    resources = []
    all_server.each do |server|
      resource = {ensure: server[:status], name: server[:name]}
      resources << new(resource)
    end
    resources
  end

  def self.prefetch(resources)
    # get a list of all servers and create a resource of them?
    # https://github.com/elastic/puppet-elasticsearch/blob/master/lib/puppet/provider/elasticsearch_service_file/ruby.rb#L45
    servers = instances
    resources.keys.each do |name|
      if (provider = servers.find{|server| server.name == name})
        resources[name].provider = provider
      end
    end
  end

  def self.all_server
    server = []
    output = hcloud(['server', 'list'])
    output.lines.drop(1).each do |line|
      ary = line.split()
      hash = {id: ary[0], name: ary[1], status: ary[2], ipv4: ary[3], ipv6: ary[4]}
      server << hash
    end
    server
  end

  def status
    # return 'absent' if the server doesn't exist
    output = server_details
    output == nil ? 'absent' : output.lines[2].split[1]
  end

  def ensure
    # returns the value for the ensure property
    case status
    when 'running'
      'running'
    when 'off'
      'off'
    else
      'absent'
    end
  end

  def started?
    status == 'running'
  end

  def server_type
    output = server_details
    output.lines[4].split[2] unless output.nil?
  end

  def server_type=(value)
    # we can only change the type, if the server is powered off
    stop_server if started?
    hcloud(['server', 'change-type', resource[:name], value])
  end

  def stop_server
    hcloud(['server', 'poweroff', resource[:name]])
  end

  def create_image(type)
    # type has to be snapshot or backup
    hcloud(['server', 'create-image', '--type', type, resource[:name]])
  end

  def create_backup
    create_image('backup')
  end

  def create_snapshot
    create_image('snapshot')
  end

  def datacenter

  end

  def datacenter=(value)

  end

  def location
    resource[:location]
  end

  def location=(value)

  end

  def image
    output = server_details
    output.lines.drop(22)[4].split[1] unless output.nil?
  end

  def image=(value)

  end

  def ssh_keys
    resource[:ssh_keys]
  end

  def ssh_keys=(value)

  end

  def user_data

  end

  def user_data=(value)

  end

  def ipv4
    output = server_details
    output.lines[14].split[1] unless output.nil?
  end

  def ipv4=(value)

  end

  def ipv6
    output = server_details
    output.lines[18].split[1] unless output.nil?
  end

  def ipv6=(value)
    Puppet.debug("you're trying to change the ipv6 prefix from #{resource[:name]} to #{value}, this won't work. It is a read only property")
  end
end
