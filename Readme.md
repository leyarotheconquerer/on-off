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

License and Credit
------------------
This project is usable under the MIT license (see [here](./License.md)).

It heavily uses the Urho3D library/engine which is licensed under the MIT license
and may be found [here](https://github.com/urho3d/Urho3D).

It uses a font under the [OFL (SIL Open Font License)](http://scripts.sil.org/OFL)
