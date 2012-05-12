#!/bin/bash
# Shell script to install Apache httpd, PHP, MySQL, and phpMyAdmin
# Run this script as su -
# Version 0.1
# May 11, 2012
# Copyright (c) 2012 Blake McCulley <http://enile8.org>
# https://github.com/enile8/fedora-lamp-sh
# This script is licensed under GNU GPL version 2.0 or above
#==========================================================================
echo -n "This script will install a complete LAMP stack on Fedora 16
"
echo -n "Would you like to install PHP, Python, or Perl: "
read lang

if [ "${lang,,}" = "php" ]
then
	echo "Would you like to install phpMyAdmin (y/N)"
	read padmin
fi

# make sure the system is up to date
yum -y update

#check if httpd is already installed
is_httpd=`rpm -q httpd`
if [ "$is_httpd" = "package httpd is not installed" ]
then
	yum install httpd
	sleep 5
	# configure the service to start automatically
	/sbin/chkconfig httpd on
	# start the server now for the rest of the process to cont.
	/sbin/service httpd start
	# make sure the server is accessible
	system-config-firewall-tui

	# moving on the MySQL
	yum install mysql mysql-server
	# start MySQL
	/sbin/service mysqld start
	sleep 5
	# set it up!
	mysql_secure_installation

	# moving on to P*
	if [ "${lang,,}" = "php" ]
	then
		yum install php php-mysql
		/sbin/service httpd restart
		sleep 5
		echo "<?php phpinfo(); ?>" > /var/www/html/index.php
		echo "This script will now open a test page 
		"
		firefox http://localhost
		echo "Was everything installed successfully (y/N)
		"
		read success
		if [ "${success,,}" = "n" ]
		then
			echo "Please file an issue so I know that it needs
			to be fixed.
			https://github.com/enile8/fedora-lamp-sh/issues
			"
		fi
		if [ "${padmin,,}" = "y" ]
		then
			yum install phpmyadmin
			echo "Alias /phpMyAdmin /usr/share/phpMyAdmin
			Alias /phpmyadmin /usr/share/phpMyAdmin" >> /etc/httpd/conf.d/phpMyAdmin.conf
			/sbin/service httpd restart
			sleep 5
		fi
		
	fi
	if [ "${lang,,}" = "python" ]
	then
		yum install mod_python MySQL-python
		/sbin/service httpd restart
	fi
	if [ "${lang,,}" = "perl" ]
	then
		yum install perl mod_perl perl-DBD-mysql
		/sbin/service httpd restart
	fi
	echo "The install is now complete!
	Thanks for using my script.
	Let me know if there were any problems.
	https://github.com/enile8/fedora-lamp-sh/issues"
else
	echo "Apache is already installed!"
fi
