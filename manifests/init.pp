class hetznercloud (
  Boolean $manage_hcloud,
  String $hcloud_package_name,
  Boolean $manage_gem,
  String $gem_name
) {
  # We can install the hcloud tool, if desired
  # it is needed if somebody wants to use the hcloud provider

  if $manage_hcloud {
    package{$hcloud_package_name:
      ensure => 'present',
    }
  }

  # the api provider needs the hcloud gem
  if $manage_gem {
    if fact('aio_agent_version') {
      $provider = 'puppet_gem'
    } else {
      $provider = 'gem'
    }
    package{$gem_name:
      ensure => 'present',
      provider => $provider,
    }
  }
}
