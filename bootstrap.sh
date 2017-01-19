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

BOOTPART=`lsblk --output NAME,MAJ:MIN --pairs --paths $ROOTDISK --sort MAJ:MIN | awk 'NR==2' | cut -d '"' -f2`
ROOTPART=`lsblk --output NAME,MAJ:MIN --pairs --paths $ROOTDISK --sort MAJ:MIN | awk 'NR==3' | cut -d '"' -f2`

mkfs.fat -F32 $BOOTPART

#let's encrypt (badly)
echo -n '123' | cryptsetup -v luksFormat $ROOTPART
echo -n '123' | cryptsetup open $ROOTPART cryptroot
mkfs.ext4 /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount $BOOTPART /mnt/boot

pacstrap /mnt base
genfstab -U /mnt > /mnt/etc/fstab

ROOTUUID=`blkid -s UUID -o value $ROOTPART`

cat <<EOF > /mnt/bootstrap.sh
#!/bin/sh
set -e
set -x

#ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
locale-gen

bootctl --path=/boot install
mkdir -p /boot/loader/entries
cp /usr/share/systemd/bootctl/loader.conf /boot/loader/loader.conf
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/arch.conf
sed -i "s/root=PARTUUID=XXXX/cryptdevice=UUID=$ROOTUUID:cryptroot/g" /boot/loader/entries/arch.conf
sed -i 's/rootfstype=XXXX/root=\/dev\/mapper\/cryptroot/g' /boot/loader/entries/arch.conf
sed -i 's/block filesystems keyboard/block encrypt filesystems keyboard/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

pacman -S --noconfirm git python2-pygit2 salt

salt-call saltutil.sync_grains -l debug
salt-call state.apply laptop -l debug

echo yes | pacman -S --clean --clean
passwd -l root
exit
EOF

mkdir -p /mnt/etc/salt/minion.d
mkdir -p /mnt/var/log/salt

cat <<EOF > /mnt/etc/salt/minion.d/masterless.conf
failhard: True
file_client: local
fileserver_backend:
  - git
gitfs_remotes:
  - https://github.com/alxbse/dotfiles.git
EOF

if [ -f "dotfiles.sls" ]; then
mkdir /mnt/srv/pillar
cp dotfiles.sls /mnt/srv/pillar/dotfiles.sls
cat <<EOF > /mnt/srv/pillar/top.sls
base:
  '*':
    - dotfiles
EOF
fi

chmod +x /mnt/bootstrap.sh
arch-chroot /mnt /bootstrap.sh
rm /mnt/bootstrap.sh

umount /mnt/boot
umount /mnt
