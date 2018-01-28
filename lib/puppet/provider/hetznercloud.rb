# written by Tim Meusel
# based on stuff from Alex
# https://github.com/OrdnanceSurvey/puppet-fme/blob/master/lib/puppet/feature/restclient.rb
# https://github.com/OrdnanceSurvey/puppet-fme/blob/master/lib/puppet/provider/fme_user/rest_client.rb#L2
# https://github.com/OrdnanceSurvey/puppet-fme/blob/master/lib/puppet/provider/fme.rb
require 'puppet/provider'
require 'yaml'
require 'hcloud' if Puppet.features.hcloud_gem?

class Puppet::Provider::Hetznercloud < Puppet::Provider
  confine feature: :hcloud_gem

  def self.prefetch(resources)
    instances.each do |instance|
      if resource = resources[instance.name] # rubocop:disable Lint/AssignmentInCondition
        resource.provider = instance
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :running
  end

  def connect
    @settings = YAML.load(File.read('/tmp/settings.yaml'))
  end

  def initialize
    @connect ||= connect
    @client ||= Hcloud::Client.new(token: settings['token'])
  end

  attr_reader :settings

  def servers
    @client.servers
  end
end
