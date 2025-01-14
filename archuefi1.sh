#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch2018
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг XFCE, темы, программы и т.д.).

# Автор скрипта Алексей Бойко https://vk.com/ordanax


loadkeys ru
setfont cyr-sun16
echo 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'
echo 'Ссылка на чек лист есть в группе vk.com/arch4u'

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo '2.4 создание разделов'
(
 echo g;

 echo n;
 echo ;
 echo;
 echo +300M;
 echo y;
 echo t;
 echo 1;

 echo n;
 echo;
 echo;
 echo +30G;
 echo y;
 
  
 echo n;
 echo;
 echo;
 echo;
 echo y;
  
 echo w;
) | fdisk /dev/sdc

echo 'Ваша разметка диска'
fdisk -l

echo '2.4.2 Форматирование дисков'

mkfs.fat -F32 /dev/sdc1
mkfs.ext4  /dev/sdc2
mkfs.ext4  /dev/sdc3

echo '2.4.3 Монтирование дисков'
mount /dev/sdc2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/sdc1 /mnt/boot/efi
mount /dev/sdc3 /mnt/home

echo '3.1 Выбор зеркал для загрузки.'
rm -rf /etc/pacman.d/mirrorlist
wget https://git.io/mirrorlist
mv -f ~/mirrorlist /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL git.io/archuefi2.sh)"
