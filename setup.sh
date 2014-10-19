#! /bin/bash

gpios=(0 1 2 3 4 7 8 9 10 11 14 15 17 1822 23 24 25  28 29 30 31);

wait_reboot=2
wait_shutdown=5

containsElement () {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

config_path=/etc/resetpi.conf
daemon_path=/etc/resetpi.py

# promt for pin number
read -p "Select GPIO [0 1 2 3 4 7 8 9 10 11 14 15 17 18 22 23 24 25 28 29 30 31]: " listen_at_pin

containsElement $listen_at_pin "${gpios[@]}"

if [ "$?" == 0 ]
	then
		echo "selected gpio $listen_at_pin"
		
		config_tpl=$(<./install/resetpi.conf)
		printf "$config_tpl" $listen_at_pin $wait_reboot $wait_shutdown > $config_path
		echo "configuration saved in '$config_path'"
		
		
		sudo cp ./install/resetpi.py $daemon_path
		echo "listener script copied to $daemon_path"
		
		sudo chown root:root $daemon_path
		sudo chmod +x $daemon_path
		echo "permissions set"
		
		# write to rc.local
		if grep -Fq "$daemon_path" /etc/rc.local
		then
			echo "already runs at startup..."
		else
			sudo sed -i -e '$i \/etc/resetpi.py &\n' /etc/rc.local
			echo "Config updated"
		fi
		sudo /etc/resetpi.py &			
		# ask for reboot
	#	while true; do
	#		read -p "Reboot now? [y/N]" yn
	#		case $yn in
	#		[Yy]* ) sudo reboot;exit;;
	#		* ) exit ;;
	#		esac
	#	done

	else
		echo "no such gpio: $listen_at_pin"
fi

exit


# write to /etc/resetpi.conf



# move to /var/reset
# append 
