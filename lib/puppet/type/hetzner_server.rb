# https://docs.hetzner.cloud/#resources-servers-post
Puppet::Type.newtype(:hetzner_server) do
  newproperty(:ensure) do
    desc 'the current server status, running, absent or off'
    newvalue(:running) do # server exists and is running
      if !provider.exists?
        provider.create
      else
        provider.start unless provider.started?
      end
    end
    newvalue(:absent) do # server doesn't exist
      provider.destroy if provider.exists?
    end
    newvalue(:off) do # server exists and is stopped
      if provider.exists?
        provider.stop unless provider.started?
      else
        provider.create
      end
    end
    defaultto(:running)
  end

  desc 'Creates a new server. Returns preliminary information about the server as well as an action that covers progress of creation'

  newparam(:name, namevar: true) do
    desc 'Name of the server to create (must be unique per project and a valid hostname as per RFC 1123)'
  end

  newproperty(:server_type) do
    desc 'ID or name of the server type this server should be created with'
    validate do |value|
      raise Puppet::Error, 'invalid parameter for server_type, expected string' unless value.is_a? String
    end
  end

  newproperty(:datacenter) do
    desc 'ID or name of datacenter to create server in'
    validate do |value|
      raise Puppet::Error, 'invalid parameter for datacenter, expected string' unless value.is_a? String
    end
    # get a list of datacenters
    # newvalues(datacenters)
  end

  newproperty(:location) do
    desc 'ID or name of location to create server in'
    validate do |value|
      raise Puppet::Error, 'invalid parameter for location, expected string' unless value.is_a? String
    end
  end

  newproperty(:image) do
    desc 'ID or name of the image the server is created from'
    validate do |value|
      raise Puppet::Error, 'invalid parameter for image, expected string' unless value.is_a? String
    end
  end

  newproperty(:ssh_keys, array_matching: :all) do
    desc 'SSH key IDs which should be injected into the server at creation time'
    # validate do |value|
    # raise Puppet::Error, 'invalid parameter for ssh_keys, expected array' unless value.is_a? Array
    # end

    # this would be a good idea, but we can't check which keys are currently in the systems, so is is always nil::NilClass :(
    # def insync?(is)
    #  is.sort == should.sort
    # end
  end

  newproperty(:user_data) do
    desc 'Cloud-Init user data to use during server creation'
    validate do |value|
      raise Puppet::Error, 'invalid parameter for user_data, expected string' unless value.is_a? String
    end
  end

  newproperty(:ipv4) do
    desc 'the ipv4 address of the server. Readonly property'
  end

  newproperty(:ipv6) do
    desc 'the ipv6 prefix of the server. Readonly property'
  end
end
