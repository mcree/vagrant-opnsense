# Packer template for running OPNSense using Vagrant with VirtualBox as a provider
Based on: https://github.com/EugenMayer/opnsense-starterkit

The box is set up with 4 network interfaces:

* em0 - VAGRANT interface - nat network - port 22 and 443 forwarded to the host by default
* em1 - LAN interface - internal network - disabled by default
* em2 - WAN interface - internal network - disabled by default
* em3 - DMZ interface - internal network - disabled by default

Basic proposed usage is demonstrated in the [/test](/test) directory 
