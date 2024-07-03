#!/bin/sh

# rc-update add vsftpd default
# rc-service vsftpd restart

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
	user_sub_token=$WP_ADMIN
	local_root=/home/$WP_ADMIN/ftp
	pasv_enable=YES
	pasv_min_port=40000
	pasv_max_port=40100
	userlist_enable=YES
	userlist_file=/etc/vsftpd.userlist
	userlist_deny=NO" >> /etc/vsftpd/vsftpd.conf

	# useradd -m -d /home/$WP_ADMIN -g $WP_ADMIN
	adduser $WP_ADMIN --disabled-password
	echo "$WP_ADMIN:$WP_ADMIN_PWD" | chpasswd

	#create ftp folder for user, only allow user to make changes in uploads folder
	mkdir -p /home/$WP_ADMIN/ftp
	chown nobody:nogroup /home/$WP_ADMIN/ftp
	chmod a-w /home/$WP_ADMIN/ftp
	mkdir -p /home/$WP_ADMIN/ftp/uploads
	chown $WP_ADMIN:$WP_ADMIN /home/$WP_ADMIN/ftp/uploads

	#add user to ftpuser list
	echo $WP_ADMIN | tee -a /etc/vsftpd.userlist

fi

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

#adduser vs useradd
# -adduser is higher level, and automatically creates users with defaults such as automatically creating home directory and config files
# -useradd is lower level and allows more control with manual options - better for scripts
# -d <home_directory>: Specify the home directory.
# -m: Create the home directory.
# -s <shell>: Specify the login shell.
# -G <group>: Specify supplementary groups.
# -u <uid>: Specify the user ID.
# -c <comment>: Provide a comment (usually the user's full name).
# in alpine, install shadow package to use useradd

#http://vsftpd.beasts.org/vsftpd_conf.html