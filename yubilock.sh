#!/bin/bash

# Based on: https://www.dalemacartney.com/2013/01/14/locking-and-unlocking-the-gnome3-session-with-a-yubikey/

base_dir=$(dirnmae $0)
base_dir=$(realpath $base_dir)
trusted="$base_dir/trusted"
user=`ps aux | grep -v root | grep session | head -n 1 | awk '{print $1}'`

do_lock="/home/$user/.i3/lock.sh force"
do_unlock="pkill i3lock"

case "$1" in
	enable)
		echo "try locking"
		su $user -c "DISPLAY=:0 $do_lock"
	;;
	disable)
		echo "try unlocking"
		if [ -n ${user} -a "$(grep -c ${user}:$(ykinfo -q -s) ${trusted})" == "1" ]; then
			$do_unlock
		fi
	;;
esac
