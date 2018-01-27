# puppet-hetznercloud

A module to manage cloud instances via the Hetzner API

## Examples

### Create a simple server

```
puppet resource hetzner_server test3 image=centos-7 server_type=cx11
```

This will create a server called test3, with a CentOS 7 image and the CX11 resources

### List all servers

```
puppet resource hetzner_server
```

## Parameters

This custom type takes a few parameters

### ensure

Valid values are running, off, absent. Defaults to running, you can change the status from all statuses to all others

### name

The RFC1123 compliant hostname. Needs to be unique for all servers

### datacenter

Optional param, can currently be fsn1-dc8 or nbg-dc3

### location

Optional param, can currently be fsn1 or nbg1

### image

Required param, can currently be ubuntu-16.04, debian-9, centos-7 or fedora-27. In addition you can provide the ID of any existing snapshot

### ssh\_keys

Optional param. If provided it needs to be an array. You need to upload your ssh key in advance, afterwards you can refer to it by its name

### user\_data

Optional string. You can provide it, but it will be ignored

### ipv4

Read-only property. Will show the configured ipv4 address from the system

### ipv6

Read-only property, will show the configured ipv6 prefix from the system
