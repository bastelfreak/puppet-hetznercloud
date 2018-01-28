class hetznercloud (
  Boolean $manage_hcloud,
  String $hcloud_package_name,
) {
  # We can install the hcloud tool, if desired
  # it is needed if somebody wants to use the hcloud provider

  if $manage_hcloud {
    package{$hcloud_package_name:
      ensure => 'present',
    }
  }
}
