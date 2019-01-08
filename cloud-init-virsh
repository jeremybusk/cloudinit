#!/bin/bash
# apt-get install -y cloud-init cloud-image-utils
# wget https://cloud-images.ubuntu.com/daily/server/bionic/current/bionic-server-cloudimg-amd64.img
login_user="ubuntu"
login_pass="ubuntu"
cat > ssh-private-key <<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCllDeRgSzKj8kVU8RkPkzU2qg0qJwf4hvzbDayEwiVWAAAAJDzGBlP8xgZ
TwAAAAtzc2gtZWQyNTUxOQAAACCllDeRgSzKj8kVU8RkPkzU2qg0qJwf4hvzbDayEwiVWA
AAAEAPmdjgNUj2lpmlT6Rp1adfKh1IT85RtXKJBxJ4f/dyoqWUN5GBLMqPyRVTxGQ+TNTa
qDSonB/iG/NsNrITCJVYAAAADGJ1c2tAYnVzay1wYwE=
-----END OPENSSH PRIVATE KEY-----
EOF

vm_guest_name="vtest"
base_os_backing_img="bionic-server-cloudimg-amd64.img"
copy_on_write_img="test-cloudinit.qcow2"
cloudinit_seed_img="cloudinit-seed.img"

rm -f $cloudinit_seed_img || true 
cat > user-data <<EOF
#cloud-config
password: $login_pass 
chpasswd: { expire: False }
ssh_authorized_keys: 
  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKWUN5GBLMqPyRVTxGQ+TNTaqDSonB/iG/NsNrITCJVY busk@busk-pc
users:
  - default
EOF
cloud-localds $cloudinit_seed_img user-data

rm -f $copy_on_write_img || true 
virsh shutdown $vm_guest_name 
virsh destroy $vm_guest_name 
virsh undefine $vm_guest_name 

qemu-img create -b $base_os_backing_img -f qcow2 \
$copy_on_write_img

virt-install -n $vm_guest_name -r 1024 --vcpus=1 \
    --disk path=$copy_on_write_img -c $cloudinit_seed_img \
    --vnc --noautoconsole --os-type linux --os-variant ubuntu18.04

echo "Connect using: virsh console $vm_guest_name"
echo "user:pass is $login_user:$login_pass"
echo "Get ipaddr: virsh domifaddr $vm_guest_name" 
echo "ssh: ssh -i ssh-private-key $login_user@<ipaddr>" 

# virsh domblklist $vm_guest_name 
# virsh change-media $vm_guest_name hda --eject --force



# TRASH
# system_info:
#   default_user:
#     name: xxxxx 

  #  -net nic -net user,hostfwd=tcp::2222-:22 \
  #  --network bridge=virbr0 \
