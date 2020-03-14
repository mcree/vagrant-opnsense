#!/bin/bash
set -e

URL=https://quantum-mirror.hu/mirrors/pub/opnsense/releases/20.1/OPNsense-20.1-OpenSSL-nano-amd64.img.bz2
SHA256SUM=27544a78ae03d480a483cfd2e7cfa703b60e50938a1ed188ec3ccde6c426fefe

cd $(dirname $0)

function setup() {
  read -rp "enter vagrand cloud token: " ct
  echo "${ct}" > .vagrant-cloud-token
}
test -f .vagrant-cloud-token || setup

mkdir -p "build-cache"
cachefile="build-cache/${SHA256SUM}.img"

if [[ ! -f "${cachefile}" ]]; then
    curl "${URL}" -o "${cachefile}.bz2"
    calcsum=$(sha256sum "${cachefile}.bz2" | awk '{print $1}')
    if [[ "${calcsum}" != "${SHA256SUM}" ]]; then
        echo "! checksum mismatch: found ${calcsum}"
        exit 1
    fi
    bunzip2 "${cachefile}.bz2"
fi

#packer build template.json
vmname=$(echo "OPNSense-${SHA256SUM}" | cut -b1-18)

trap "set +e ; VBoxManage controlvm ${vmname} poweroff ; VBoxManage unregistervm --delete ${vmname}" exit

if ! VBoxManage showvminfo "${vmname}" >/dev/null 2>/dev/null; then
    VBoxManage createvm --name "${vmname}" --ostype FreeBSD_64 --register
    VBoxManage modifyvm "${vmname}" --memory 1024
    VBoxManage storagectl "${vmname}"  --name "SATA Controller" --add sata --controller IntelAhci
    VBoxManage convertdd "${cachefile}" "${cachefile}.vdi" --format VDI
    VBoxManage modifymedium "${cachefile}.vdi" --resize 5120
    VBoxManage storageattach "${vmname}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${cachefile}.vdi"
    VBoxManage snapshot "${vmname}" take "clean"
    #VirtualBox --startvm "${vmname}"
fi

ct=$(cat .vagrant-cloud-token)
VAGRANT_CLOUD_TOKEN="${ct}" packer validate -var VMNAME="${vmname}" template.json
VAGRANT_CLOUD_TOKEN="${ct}" packer build -var VMNAME="${vmname}" template.json

exit 0
