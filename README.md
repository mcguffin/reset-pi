Reset PI
========

Watch a pin signal and detect reset or shutdown commands.

Installation
------------

	cd ~
	git clone https://github.com/mcguffin/reset-pi.git
	cd reset-pi
	sudo ./setup.sh


Hardware
--------

You need:

- Button
- R1: 10K resistor
- R2: 1k resistor
- cables

Wiring
------
	
	 +---| R1 |----+
	 |             |
	 |             |
	 |             |----| R2 |---> GPIO in (31 is a good choice)
	----           |
	3.3V             /
	----            /   Switch
	 |             |
	 +-------------+
	 |             
	 V
	GND 


