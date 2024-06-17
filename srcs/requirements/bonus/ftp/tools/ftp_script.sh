#!/bin/sh

#still need config file!
#create backup file
cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

#-h sets home directory for user 
#chpasswd is a command that updates passwords in batch mode
adduser $FTP_USER --disabled-password
echo "$FTP_USER:$FTP_PWD" | chpasswd
# echo "$FTP_USER" >> /etc/vsftpd.userlist

if [ ! $(getent group ftpgroup) ]; then
	echo "Creating ftpgroup..."
	groupadd ftpgroup
fi
echo "Adding $FTP_USER to ftpgroup..."
usermod -a -G ftpgroup $FTP_USER

mkdir /home/$FTP_USER/ftp
mkdir /home/$FTP_USER/ftp/files
#if ftpgroup does not exist, create group and add ftp user
chown -R :ftpgroup /home/$FTP_USER/ftp
chmod 750 /home/$FTP_USER/ftp

# sed -i -r "s/#write_enable=YES/write_enable=YES/1"   /etc/vsftpd.conf
# sed -i -r "s/#chroot_local_user=YES/chroot_local_user=YES/1"   /etc/vsftpd.conf

# echo "
# # local_enable=YES
# # allow_writeable_chroot=YES
# # pasv_enable=YES
# # local_root=/home/hbui-vu/ftp
# # pasv_min_port=40000
# # pasv_max_port=40005
# # userlist_file=/etc/vsftpd.userlist" >> /etc/vsftpd.conf

# service vsftpd stop
# rc-update add vsftpd default
# rc-service vsftpd restart

# vsftpd
