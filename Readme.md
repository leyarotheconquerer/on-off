On/Off
======
Ludum Dare 39 (Running Out of Power)
------------------------------------

On/Off is a game allowing players to control a robot in a powered down world.
Only the robot can turn it on again. He will need to collect all the batteries
if he hopes to restore life to the now silent halls.

However, doors and chasms stand between him and the necessary power sources. He
will need to turn on the world to pass these obstacles while conserving the
precious energy he seeks.

Building
--------
On/Off is created with [Urho3D](https://urho3d.github.io) and uses
[CMake](https://cmake.org) to compile. Run the appropriate CMake generator and
build with the mechanism of your choice.
```bash
#cmake -G "<Generator-Here>" .

#For instance, using make files
cmake -G "Unix Makefiles" .
#Configure CmakeCache.txt here
make
make install
```

You will need to set URHO3D_HOME in the CMakeCache.txt before building as this
project requires Urho3D.

Running
-------
Run the generated binary at `bin/onoff`

Concept Guidance
---------------
- On or Off
	* The world can be turned on or off
	* You have the power switch
	* But the world can only stay on for so long
	* There is limited power
	* Complete each section of each level to get batteries for the world
	* Finish the levels before the world runs out of power
	* Obstacles stop you from getting batteries
	* Obstacles include:
		+ Doors
		+ Bridges
		+ Spikes
		+ Pistons from above?
