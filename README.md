# bind_server Cookbook

This cookbook is used to create dns server and a slave or secondary nameserver

### Chef

- Chef 12.0 or later

## Usage

### dns_server::default
Use the above said recipe in the nodes you want to convert to `dns_server`

e.g.
Just include `dns_server` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[dns_server]"
  ]
}
```

## Attributes
For master dns server

*  default["dns"]["domain"]             = "gojek.com" 
*  default["reverse"]["dns"]             = "10"
*  default['primary_nameserver_ip']       = '127.0.0.1'


Additional parameters for secondary nameserver:
* default['master_nameserver_ip']

## Dev Setup
1. `git clone git@github.com:alexis-lxc/bind_server_cookbook.git`
2. kitchen converge
3. test

## Contributing 

Feel free to review modify and use it as you wish :)
