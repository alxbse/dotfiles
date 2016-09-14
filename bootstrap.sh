#!/bin/sh
set -e
set -x

if [ ! -d "/sys/firmware/efi/efivars" ]; then
	echo "no efivars, are you sure UEFI is enabled?"
	exit 1
fi

ROOTDISK=`lsblk --output NAME,LABEL,SIZE --nodeps --paths --sort SIZE --pairs | grep --invert-match ARCH | tac | head -n 1 | cut -d '"' -f2`

cat <<EOF > /tmp/gdisk
o
Y
n


+256M
ef00
n




w
Y
EOF

gdisk $ROOTDISK < /tmp/gdisk

BOOTPART=`lsblk --output NAME,PARTLABEL --pairs --paths $ROOTDISK | awk 'NR==2' | cut -d '"' -f2`
ROOTPART=`lsblk --output NAME,PARTLABEL --pairs --paths $ROOTDISK | awk 'NR==3' | cut -d '"' -f2`

mkfs.fat -F32 $BOOTPART
mkfs.ext4 $ROOTPART

echo "mounting partitions"
mount $ROOTPART /mnt
mkdir /mnt/boot
mount $BOOTPART /mnt/boot

pacstrap /mnt base
genfstab -U /mnt > /mnt/etc/fstab

ROOTUUID=`blkid -s PARTUUID -o value $ROOTPART`

cat <<EOF > /mnt/opt/bootstrap.sh
#!/bin/sh
set -e
set -x

ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
locale-gen

bootctl --path=/boot install
mkdir -p /boot/loader/entries
cp /usr/share/systemd/bootctl/loader.conf /boot/loader/loader.conf
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/arch.conf
sed -i "s/PARTUUID=XXXX/PARTUUID=$ROOTUUID/g" /boot/loader/entries/arch.conf
sed -i 's/rootfstype=XXXX/rootfstype=ext4/g' /boot/loader/entries/arch.conf

pacman -S --noconfirm git python2-pygit2 salt-zmq sudo

salt-call --local state.apply laptop
exit
EOF

mkdir -p /mnt/etc/salt/minion.d
mkdir -p /mnt/var/log/salt

cat <<EOF > /mnt/etc/salt/minion.d/masterless.conf
file_client: local
fileserver_backend:
  - git
gitfs_remotes:
  - https://github.com/alxbse/dotfiles.git
EOF


chmod +x /mnt/opt/bootstrap.sh

arch-chroot /mnt /opt/bootstrap.sh
