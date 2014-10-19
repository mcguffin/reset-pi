#!/usr/bin/python

import RPi.GPIO as GPIO
from datetime import datetime
import calendar, os, time

# read pin from /etc/resetpi.conf
# if not pin, exit

def now():
	t = datetime.utcnow()
	return calendar.timegm( t.utctimetuple() )

def shutdown():
	print "Shutdown signal recieved from switch."
 	os.popen("sudo shutdown -h now");

def reboot():
	# shutdown -h now
	print "Reboot signal recieved from switch."
 	os.popen("sudo reboot");


# set defaults
listen_at_pin = 31
wait_reboot = 2
wait_shutdown = 5


print "Reset Button Watcher"
print "--------------------"

try:
	exec(open('/etc/resetpi.conf').read())
except IOError:
	print "the configuration file ist not present. Using default values."

# configure pin
GPIO.setmode( GPIO.BCM )
GPIO.setup( listen_at_pin , GPIO.IN )


print "Watching pin %d" % listen_at_pin
print "---------------------------------------------------------"
print "Reboot:   Press button for at least %d seconds, then release" % wait_reboot
print "Shutdown: Keep button pressed for at least %d seconds" % wait_shutdown


# used during runtime
old_input = -1
seconds_since_press = 0
button_pressed = 0

while True:
	input = GPIO.input( listen_at_pin )

	# detect reboot
	if old_input != input:
		started = now()
#		print old_input,input,seconds_since_press
		if old_input == 0 and input == 1 and seconds_since_press >= wait_reboot: # release button
			reboot()
			break
		elif old_input == 1 and input == 0: # press button
			button_pressed = now()
		old_input = input

	seconds_since_press = now() - button_pressed

	# detect shutdown
	if input == 0 and seconds_since_press >= wait_shutdown:
		shutdown()
		break
