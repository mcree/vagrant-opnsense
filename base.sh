#!/bin/sh
#echo "upgrading opnsense"
#opnsense-update
#echo "cleanup"
#opnsense-update -e
echo 'autoboot_delay="0"' >> /boot/loader.conf

#pw useradd -n vagrant -u 0 -c "vagrant" -s /bin/csh -m -w yes
#pw groupmod wheel -m vagrant
#pw groupmod admins -m vagrant
#pw groupmod operator -m vagrant
#echo '%vagrant ALL=NOPASSWD:ALL' > /usr/local/etc/sudoers.d/vagrant
