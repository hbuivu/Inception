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
	user_sub_token=$WP_ADMIN_USER
	local_root=/home/$WP_ADMIN_USER/ftp
	pasv_enable=YES
	pasv_min_port=40000
	pasv_max_port=40100
	userlist_enable=YES
	userlist_file=/etc/vsftpd.userlist
	userlist_deny=NO" >> /etc/vsftpd/vsftpd.conf

	cat /etc/vsftpd/vsftpd.conf

	adduser $WP_ADMIN_USER --disabled-password
	# echo "$WP_ADMIN_USER:$FTP_PSWD" | /usr/bin/passwd
	echo "$WP_ADMIN_USER:$WP_ADMIN_PWD" | chpasswd

	#create ftp folder for user, only allow user to make changes in uploads folder
	mkdir -p /home/$WP_ADMIN_USER/ftp
	chown nobody:nogroup /home/$WP_ADMIN_USER/ftp
	chmod a-w /home/$WP_ADMIN_USER/ftp
	mkdir /home/$WP_ADMIN_USER/ftp/uploads
	chown $WP_ADMIN_USER:$WP_ADMIN_USER /home/$WP_ADMIN_USER/ftp/uploads

	#add user to ftpuser list
	echo $WP_ADMIN_USER | tee -a /etc/vsftpd.userlist
fi

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
# rc-service vsftpd restart

# configure firewall and add 21, 21, and minport:pasv_max_port
# sudo ufw allow from any to any port 20, 21, 100000:101000 proto tcp
# create demo file inside folder
# sudo systemctl restart vsftpd (restart to apply changes)

# add ssl certificates?
# see rsa_cert_file=
# rsa_private_key_file= 
# ssl_enable=NO -> YES
# allow_anon_ssl=NO
# force_local_data_ssl=YES
# force_local_logins_ssl=YES

#http://vsftpd.beasts.org/vsftpd_conf.html