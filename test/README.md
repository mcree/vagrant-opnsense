# Sample setup for vagrant-opnsense box

## Setup

The setup contains an OPNSense based firewall
with three zones (WAN, LAN and DMZ).

A workstation (running windows 10) is conntected
to the LAN zone, while a server (running ubuntu)
is connected to the DMZ zone.

The networks are set up as the following:

* *WAN* is a VirtualBox based NAT network
  * Only the firewall (**fw**) is connected to this network
  * **fw** is configured as a DHCP client
  * Firewall
* *LAN* is a VirtualBox internal network with the same name ("LAN")
  * **fw** and windows 10 workstation (**lanws**) is connected to
    this network
  * **fw** is acting as a DHCP server and default gateway
  * **lanws** is acting as a DHCP client
* *DMZ* is another VirtualBox internal network with the same name ("DMZ")
  * **fw** and ubuntu server (**dmzsrv**) is connected to this network
  * **fw** is acting as a DHCP server and default gateway
  * **dmzsrv** is acting as a DHCP client

## Letting Vagrant in while enabling operation on a closed network

Due to the nature of Vagrant, all three virtual machines
are required to have their _first_ Ethernet interface configured
as a VirtualBox NAT network. Vagrant is expecting to access
all the machines via this interface using automatic SSH and WinRM
port forwarding rules.

For this reason special configuration steps are in place for
"first" interfaces on all VMs:
* interface *em0* on **fw** is configured
  as a DHCP client with the name VAGRANT. Default gateway
  is disabled on this interface and all traffic is let in.
* interface *Ethernet* on **lanws** is configured with a 
  large default metric, so all traffic is routed towards
  the second interface
* interface *enp0s3* on **dmzsrv** is configured to ignore
  routes provided via DHCP

Similar configuration steps are needed for all
VMs on the simulated network infrastructure in order
to prevent the default Vagrant NAT interfaces to
distract traffic.
 