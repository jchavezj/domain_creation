#!/bin/bash
#
dir="/etc/httpd/vhost.d"
loc=$(pwd)
template="$loc/template"
conf="$loc/vhcreator.sh"
inc="include vhost.d/*conf"
dom="/var/www/vhost"

if [ -d $dir  ];
then
    echo "Directory $dir exists."
else
    echo "Creating directory $dir"
	mkdir -p $dir
	mkdir $dom
    	echo "Directory $dir" created
	cp $template $dir
	echo "template has been copied to $dir"
	cp $conf /usr/bin/
	echo "The $conf has been copied"
	echo $inc >>/etc/httpd/conf/httpd.conf
	echo "Installation complete"	
fi
