#!/bin/bash
#
############################################################################
#     This file is part of apache_vhost script.				   #
# 									   #
#    Apache_vhsot is free software: you can redistribute it and/or modify  #
#    it under the terms of the GNU General Public License as published by  #
#    the Free Software Foundation, either version 3 of the License, or     #
#    (at your option) any later version.				   #
# 									   #
#    apache_vhost is distributed in the hope that it will be useful,       #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#    GNU General Public License for more details.			   #
# 									   # 
#    You should have received a copy of the GNU General Public License     #
#    along with apache_vhost.  If not, see <http://www.gnu.org/licenses/>. #
#									   #
#  									   #
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
