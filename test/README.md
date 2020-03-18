# Sample setup for vagrant-opnsense box

## Test environment

The test environment contains an OPNSense based 
firewall (name: **fw**)
with three zones (WAN, LAN and DMZ). 
A Windows 10 workstation (name: **lanws**) is conntected
to the LAN zone, while an Ubuntu based server (name: **dmzsrv**)
is connected to the DMZ zone.
Configuration is described in the [Vagrantfile](Vagrantfile)

The networks are set up as the following:

* *WAN* is a VirtualBox based NAT network
  * Only the firewall (**fw**) is connected to this network
  * **fw** is configured as a DHCP client
* *LAN* is a VirtualBox internal network with the same name ("LAN")
  * **fw** and windows 10 workstation (**lanws**) is connected to
    this network
  * **fw** is acting as a DHCP server and default gateway
  * **lanws** is acting as a DHCP client
* *DMZ* is another VirtualBox internal network with the same name ("DMZ")
  * **fw** and Ubuntu server (**dmzsrv**) is connected to this network
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
* interface *em0* on **fw** with the name *VAGRANT* is configured
  as a DHCP client. Default gateway
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
 
 ## Usage
 
Download and install external requirements:
 
 * [Vagrant](https://www.vagrantup.com/downloads.html)
 * [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
 * [git](https://git-scm.com/downloads) (default options can be accepted during installation)
 
Launch a terminal then enter the following commands:

```shell script
git clone https://github.com/mcree/vagrant-opnsense.git
cd vagrant-opnsense
cd test
vagrant up
```

Then have a break. :)

After 10-20 minutes, all three VMs should be up and running.

### Access

Users and passwords for the VMs:

- **fw**: root / opnsense (web ui is exported to the host machine as: https://127.0.0.1:10443/)
- **lanws**: vagrant / vagrant (use virtualbox UI or ```vagrant rdp lanws```)
- **dmzsrv**: vagrant / vagrant (use virtualbox UI or ```vagrant ssh dmzsrv```)

