#!/bin/sh


if [ ! -f /etc/vsftpd/vsftpd.conf.bak ]; then
	cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak

	# Edit config file
	sed -i "s|anonymous_enable=YES|anonymous_enable=NO|g" /etc/vsftpd/vsftpd.conf
	#enable local users to log into ftp server
	sed -i "s|#local_enable=YES|local_enable=YES|g" /etc/vsftpd/vsftpd.conf
	#enable file and folder upload
	sed -i "s|#write_enable=YES|write_enable=YES|g" /etc/vsftpd/vsftpd.conf
	#restrict local users to home directories
	sed -i "s|#chroot_local_user=YES|chroot_local_user=YES|g" /etc/vsftpd/vsftpd.conf
	#ensure FTP server routes to directory that is meant for user
	#passive ports in case there are firewall issues between server and client at 20 and 21
	#ftp only allows users in its local database
	echo "
	listen_port=21
	listen_address=0.0.0.0
	seccomp_sandbox=NO
	user_sub_token=$FTP_USER
	local_root=/home/$FTP_GROUP/ftp
	pasv_enable=YES
	pasv_min_port=40000
	pasv_max_port=40100
	userlist_enable=YES
	userlist_file=/etc/vsftpd.userlist
	userlist_deny=NO" >> /etc/vsftpd/vsftpd.conf

	usermod -aG $FTP_GROUP $FTP_ADMIN
	echo "$FTP_USER:$WP_ADMIN_PWD" | chpasswd

	#add user to ftpuser list
	echo $FTP_USER | tee -a /etc/vsftpd.userlist

fi

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

#NOTES:
#For some reason, the ownership of uploads folder is always set to vsftp:www-data. 
#This user and group is already created
#We simply need to add vsftp to www-data group, add password, and vsftp to known vsftp userlist
