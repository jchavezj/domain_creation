#!/bin/bash
#
############################################################################
#     This file is part of vhcreator.sh script.				   #
  									   #
# <author> Johnny Chavez </author>            				   #
# <date>2014-07-29</date>						   #
# V. 0.1								   #
############################################################################

############################################################################
#		 CONFIGURATION AREA   				           #
############################################################################

# Define the location of the  vHost Template
template="/etc/httpd/conf.d/template"

# Define the location where apache looks for vhost configs
confdir="/etc/httpd/vhost.d"

# Define where the domain folders should exist
vhostdir="/var/www/vhosts"

# Define where the apache logs for this domain should exist
logdir="/var/log/httpd"

###########################################################################
# 	The following is the vhost creation			          #
##########################################################################

die () {
    echo >&2 "$@"
    exit 1
}


# Check if we have an argument, exit if not

echo " "

[ "$#" -eq 1 ] || die  " Enter the name of the domain for example: 

 ./apache_vhost.sh www.example.com
 "



# Replace domain name into template

sed "s/%%DOMAIN%%/$1/g" "$template" >  $confdir/$1.conf

# Create folder for domain
mkdir $vhostdir/$1
chown root:users $vhostdir/$1
chmod 775 $vhostdir/$1

# Create an empty index file to keep things private
touch $vhostdir/$1/index.html
chown root:users $vhostdir/$1/index.html
chmod 774 $vhostdir/$1/index.html
echo "$1 website " >  $vhostdir/$1/index.html 

# Create empty log files for apache
mkdir $logdir/$1
touch $logdir/$1/access_log
touch $logdir/$1/error_log
chown root:root $logdir/$1/access_log
chown root:root $logdir/$1/error_log
chmod 740 $logdir/$1/access_log
chmod 740 $logdir/$1/error_log

# This reloads the apache configuration

service httpd restart

# Lets the user know what just happend
echo " "
echo "The domain  $1 has been created."
echo "You can place your files in $vhostdir/$1"
echo "You can view your logs in $logdir/$1"
echo " "


###########################################################################
#       This creates the ftp user for the domain                          #
###########################################################################
#
if [ $(id -u) -eq 0 ]; then

PASS=$(openssl rand 12 -base64)

echo "Please enter FTP user for this domain: "
read ftpuser

egrep "^$ftpuser" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
echo "$ftpuser exists!"
exit 1
else

useradd -d /var/www/vhosts/$1/ -s /sbin/nologin  $ftpuser
#/usr/sbin/usermod -p echo $PASS | passwd  $ftpuser --stdin
echo $PASS |passwd $ftpuser --stdin
#
chown -R $ftpuser:$ftpuser /var/www/vhosts/$1/
echo " "
echo "The user $name has been created with the following: "
echo " The home directory is $vhostdir/$1"
echo " username: $ftpuser"
echo " password: $PASS"
echo " "
fi
fi
