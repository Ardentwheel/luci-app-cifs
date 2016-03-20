#!/bin/sh /etc/rc.common

START=99

# TEM_FILE="/var/etc/cifs.tem.conf"
MOUNTAREA=0
WORKGROUPD=0
IOCHARSET=0
DELAY=0


cifs_header() {
	local workgroup 
	local mountarea
	local delay
	local iocharset

	config_get mountarea $1 mountarea
	config_get workgroup $1 workgroup
	config_get delay $1 delay
	config_get iocharset $1 iocharset

	MOUNTAREA=$mountarea
	WORKGROUPD=$workgroup
	IOCHARSET=$iocharset

	if [ $delay != 0 ]	
	then
	DELAY=$delay
	fi

}

mount_sambashare() {
	local server
	local name
	local path
	local guest
	local users
	local pwd
	local nounix
	local arguments
	
	local _mount_path

	config_get server $1 server
	config_get name $1 name
	config_get path $1 path
	config_get guest $1 guest
	config_get users $1 users
	config_get pwd $1 pwd
	config_get nounix $1 nounix
	config_get arguments $1 arguments

	if [ $guest != 1 ] then
	GUEST=' '
	else
	GUEST=',$guest'
	fi
	

	if [ $nounix != 1 ] then
	NOUNIX=' '
	else
	NOUNIX=',$nounix'
	fi
	
	if [ $arguments != 1 ] then
	ARGUMENTS='-o $GUEST,domain=$WORKGROUPD,iocharset=$IOCHARSET$NOUNIX'
	else
	ARGUMENTS='-o $GUEST,domain=$WORKGROUPD,iocharset=$IOCHARSET$NOUNIX,$arguments'
	fi
	
	append _mount_path "$MOUNTAREA/${server}-$name"

#	sleep 1
#	mkdir -p $_mount_path


	mount -t cifs $path $_mount_path $ARGUMENTS


}

umount_sambashare() {
	local server
	local name
	local path
	local users
	local pwd
	local _mount_path

	config_get server $1 server
	config_get name $1 name
	config_get path $1 path
	config_get users $1 users
	config_get pwd $1 pwd

	append _mount_path "$MOUNTAREA/${server}-$name"

	sleep 1
	umount -r -f $_mount_path
	rm -r -f $_mount_path 
}

start() {
	config_load cifs
	config_foreach cifs_header cifs

	if [ $DELAY != 0 ]
	then
	sleep $DELAY
	echo "DELAY Operation ${DELAY}s"
	else
	echo "Not DELAY ${DELAY}s"
	fi

	config_foreach mount_sambashare sambashare
	
	echo "Cifs Mount succeed."
}

stop() {
	config_load cifs
	config_foreach cifs_header cifs
	config_foreach umount_sambashare sambashare

	echo "Cifs Umount succeed."

}

restart() {
	config_load cifs
	config_foreach cifs_header cifs
	config_foreach umount_sambashare sambashare

	if [ $DELAY != 0 ]
	then
	sleep $DELAY
	echo "DELAY Operation ${DELAY}s"
	else
	echo "Not DELAY ${DELAY}s"
	fi

	config_foreach mount_sambashare sambashare

	echo "Cifs Umount restart succeed."
}

