#!/bin/bash

# Based on: https://www.dalemacartney.com/2013/01/14/locking-and-unlocking-the-gnome3-session-with-a-yubikey/

user=`ps aux | grep -v root | grep session | head -n 1 | awk '{print $1}'`

#set -x
#exec >> /home/$user/Documents/src/yubilock/yubilock.log 2>&1
#echo date $1

base_dir=$(dirname $0)
base_dir=$(realpath $base_dir)
trusted="$base_dir/trusted"

do_lock="/home/$user/.i3/lock.sh force"
do_unlock="pkill i3lock"

case "$1" in
	enable)
		echo "try locking"
		su $user -c "bash -c \"DISPLAY=:0 $do_lock\""
	;;
	disable)
		echo "check unlocking"
		if [ -n ${user} -a "$(grep -c ${user}:$(ykinfo -q -s) ${trusted})" == "1" ]; then
			echo "trused -> unlock"
			$do_unlock
		fi
	;;
esac
