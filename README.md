# RandomSpawn

**Requires [DataManager](https://github.com/tes3mp-scripts/DataManager)!**

Randomize where new players spawn, comes with default spawn points that are fully configurable.

Heavily based on [ccSuite](https://github.com/Texafornian/ccSuite)'s implementation, special thanks to Texafornian for making that!

## Installation

1. Place this repo into your `CoreScripts/scripts/custom/` directory.

1. Add the following to `CoreScripts/scripts/customScripts.lua`:

        ...
        -- DataManager needs to before RandomSpawn, like this
        DataManager = require("custom/DataManager/main")

        require("custom/tes3mp-randomspawn/main")

1. Ensure that `DataManager` loads before this mod as seen above.

1. Optionally configure RandomSpawn by editing the `CoreScripts/data/custom/__config_RandomSpawn.json` file (see below).

## Configuration

* `useProvinceCyrodiilSpawns`

Boolean.  Whether or not to include Province Cyrodiil spawn points.  Default: `false`

* `useTamrielRebuiltSpawns`

Boolean.  Whether or not to include Tamriel Rebuilt spawn points.  Default: `false`

* `useTamrielRebuiltPreviewSpawns`

Boolean.  Whether or not to include Tamriel Rebuilt Preview content spawn points.  Default: `false`

* `useSkyrimHomeOfTheNordsSpawns`

Boolean.  Whether or not to include Skyrim: Home of the Nords spawn points.  Default: `false`

* `useVanillaSpawns`

Boolean.  Whether or not to include spawn points from the vanilla Morrowind game.  If no other spawn points are enabled, the default value of these are selected from.  Default: `false`

* `customSpawns`

An array containing arrays with each of your custom spawn points.  See below for information on adding new spawn points.

## Adding New Spawn Points

The format of a spawn point is:

    ["Cell ID", X coord, Y coord, Z coord, Z rotation, "Displayed Name"]

The easiest way to obtain all of this information in one place is:

1. Log into a server
1. Move your player to the place you'd like to add as a spawn point, including the direction and angle they'd be facing.
1. Log off
1. Open the player's json file
1. Look for "`location`", just below that you will see values for `cell`, `posX`, `posY`, `posZ`, and `rotZ` - use those but only `rotZ` should be taken with the decimal (as a float; use the same precision as the defaults in this script)
