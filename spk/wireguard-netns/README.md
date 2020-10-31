# WireGuard netns scripts

Place your WireGuard configs in [`src/wg`](src/wg), named as `{NETNS}.conf`.
The service will create a network namespace named `{NETNS}`,
containing a WireGuard interface `wg-{NETNS}` and a virtual ethernet device `vp-{NETNS}`,
the other end of which is `ve-{NETNS}` and lives in the initial namespace.
For this reason `{NETNS}` should be relatively short (12 characters tops).

Also add a file `defaults` with the following contents:
```bash
# private IPv4 subnet to use for the virtual ethernet devices
subnet='10.111.0.0/16`
# WireGuard configs to enable by default
enabled=('vpn1' 'vpn2')
```
The subnet should hold at least twice as many usable addresses as there are WireGuard configs.
Make sure they don't conflict with other devices on the network (in particular, the WireGuard device(s)).
Entries in `enabled` should match one of the WireGuard configs.

To make a service inside the namespace `{NETNS}` accessible from the LAN,
have it listen on the address in `/usr/local/etc/wireguard-netns/$(ip netns identify)/host`.
