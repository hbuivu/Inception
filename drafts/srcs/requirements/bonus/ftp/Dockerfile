# NOTES:
	# FTP = file transfer protocol server
	# facilitates transfer of files over a TCP/IP network using FTP protocol
	# Used to upload and manage website files on a web server
	# Share files internally and externallyw ith clients and partners
	# backup and store important files and data
	# not a secure protocol
FROM alpine:3.18.0

RUN apk update && \
	apk add --no-cache vsftpd openrc

ADD tools/ftp_script.sh tmp/ftp_script.sh

# EXPOSE 20 21
EXPOSE 21

ENTRYPOINT ["./tmp/ftp_script.sh"]




