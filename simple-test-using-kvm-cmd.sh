#!/bin/bash
wget https://cloud-images.ubuntu.com/daily/server/bionic/current/bionic-server-cloudimg-amd64.img
base_os_backing_img="bionic-server-cloudimg-amd64.img"
copy_on_write_img="test-cloudinit.qcow2"
cloudinit_seed_img="cloudinit-seed.img"
cat > user-data <<EOF
#cloud-config
password: passw0rd
chpasswd: { expire: False }
EOF
cloud-localds $cloudinit_seed_img user-data

rm -f $copy_on_write_img
qemu-img create -b $base_os_backing_img -f qcow2 \
$copy_on_write_img

# # kvm command example, need gui
kvm -m 1024 \
   -net nic -net user,hostfwd=tcp::2222-:22 \
   -drive file=$copy_on_write_img,if=virtio,format=qcow2 \
   -drive file=$cloudinit_seed_img,if=virtio,format=raw
