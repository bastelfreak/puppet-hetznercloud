# provider based on the RESTful API
# https://docs.hetzner.cloud

Puppet::Type.type(:hetzner_server).provide(:api, parent: Puppet::Provider::Hetznercloud) do
  desc 'A REST API based provider to manage the hetzner cloud servers'
end
