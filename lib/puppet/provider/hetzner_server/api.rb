# provider based on the RESTful API
# https://docs.hetzner.cloud

Puppet::Type.type(:hetzner_server).provide(:api) do

  desc 'A REST API based provider to manage the hetzner cloud servers'
end
