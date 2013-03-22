eyetvtool
=========

Command line tool to list/export/remove and modify EyeTV recordings and schedules.

This is a tool to setup/edit/delete and export programs and recordings from EyeTV. This supports both version 2 and version 3. But requires code changes depending on the version.


    Eye TV Tool.  A command line interface for controlling the Eye TV PVR software.
    Usage eyetvtool [OPTION]

    Actions:
    --export     Export selected recordings
    --delete     Delete selected recordings or programs
    -n --new     Create a new program
    -E --enable  Enable a program
    -D --disable Disable a program
    -h --help    This help

    Selecting programs and recordings:
    If nothing is selected here, every program and recording is selected.
    -t --title <title> Select matching sub string
    -i --id <id>       Select matching id.  id can be a range eg 1234-1245
    -Y --yes           Allow actions on every program and recording
    -R --recordings    Select only recordings (don't select programs)
    -P --programs      Select only programs (don't select recordings)

    Set program data:
    -s --start <YYYY-MM-DD HH:MM:SS> Set start time of a program
    -u --settitle <title>            Set the title of a program or recording
    -l --length <seconds>            Set the record duration of a program
    -p --repeats <days>              Set the repeats of the program
               [None|Sund|Mond|Tues|Wedn|Thur|Frid|Satu|Week|Wknd|Dail] comma separated for multiple days
    -C --channel <channel>           Set the channel number of the program

example output showing all recordings and programs (scheduled recordings)
-------------------------------------------------------------------------
    ./eyetvtool
    2013-03-22 15:06:17.164 eyetvtool[3658:903] RECORDINGS

    384946080: Star Trek: Deep Space Nine, 2013-03-14 20:28:00 +1100, 3:18:59
    385025220: In The Night Garden, 2013-03-15 18:27:00 +1100, 0:35:59
    385030980: Good Game SP, 2013-03-15 20:03:00 +1100, 0:29:59
    385118221: Good Game: Pocket Edition, 2013-03-16 20:17:01 +1100, 0:17:58
    385288200: My Kitchen Rules, 2013-03-18 19:30:00 +1100, 1:24:58
    385370820: In The Night Garden, 2013-03-19 18:27:00 +1100, 0:36:59
    385378200: Good Game, 2013-03-19 20:30:00 +1100, 0:32:59
    385457220: In The Night Garden, 2013-03-20 18:27:00 +1100, 0:35:59

    2013-03-22 15:06:17.393 eyetvtool[3658:903] PROGRAMS

    352123129: Star Trek: Deep Space Nine, 2013-03-28 20:30:00 +1100, 3:15:00, 11, ELEVEN, Thursday, ENABLED
    365158421: You're Skitting Me, 2013-03-24 09:40:00 +1100, 0:35:00, 23, ABC3, Sunday, DISABLED
    365306407: Horrible Histories, 2013-03-21 19:00:00 +1100, 0:25:00, 23, ABC3, Monday;Tuesday;Wednesday;Thursday, DISABLED
    371129477: Deadly 60, 2013-03-21 18:30:00 +1100, 1:00:00, 23, ABC3, Weekdays, DISABLED
    377616067: Play School, 2013-03-21 09:30:00 +1100, 0:30:00, 22, , Weekdays, DISABLED
    377616154: Play School, 2013-03-21 15:00:00 +1100, 0:30:00, 2, , Weekdays, DISABLED
    384766325: Good Game SP, 2013-03-15 20:03:00 +1100, 0:29:59, 23, , None, ENABLED
    384766328: In The Night Garden, 2013-03-15 18:27:00 +1100, 0:35:59, 22, , None, ENABLED
    384939131: In The Night Garden, 2013-03-17 18:27:00 +1100, 0:35:59, 22, , None, ENABLED
    384939133: In The Night Garden, 2013-03-19 18:27:00 +1100, 0:36:59, 22, , None, ENABLED

I have manually removed some of the entries for easier reading.

Show all programes within a recording ID range
----------------------------------------------

    ./eyetvtool -P -i 385457822-385526288

    2013-03-22 15:10:38.727 eyetvtool[3669:903] PROGRAMS

    385457822: Good Game, 2013-03-26 20:30:00 +1100, 0:31:00, 22, , None, ENABLED
    385457823: In The Night Garden, 2013-03-22 18:29:00 +1100, 0:33:00, 22, , None, ENABLED
    385457824: In The Night Garden, 2013-03-26 18:29:00 +1100, 0:33:00, 22, , None, ENABLED
    385457825: In The Night Garden, 2013-03-27 18:28:00 +1100, 0:34:00, 22, , None, ENABLED
    385457826: In The Night Garden, 2013-03-28 18:29:00 +1100, 0:33:00, 22, , None, ENABLED
    385465620: My Kitchen Rules, 2013-03-20 20:47:01 +1100, 0:04:54, 7, , None, ENABLED
    385518974: Good Game SP, 2013-03-30 09:05:00 +1100, 0:26:00, 23, , None, ENABLED
    385518975: In The Night Garden, 2013-03-29 18:29:00 +1100, 0:32:00, 22, , None, ENABLED
    385526288: Good Game SP, 2013-03-29 20:06:00 +1100, 0:26:00, 23, , None, ENABLED

Show all recordings which have Game in their title.
---------------------------------------------------

    ./eyetvtool -R -t Game
    2013-03-22 15:11:37.040 eyetvtool[3671:903] RECORDINGS

    385030980: Good Game SP, 2013-03-15 20:03:00 +1100, 0:29:59
    385077840: Good Game SP, 2013-03-16 09:04:00 +1100, 0:28:59
    385114800: Good Game SP, 2013-03-16 19:20:00 +1100, 0:28:58
    385118221: Good Game: Pocket Edition, 2013-03-16 20:17:01 +1100, 0:17:58
    385173180: Good Game SP, 2013-03-17 11:33:00 +1100, 0:29:58
    385205760: Good Game SP, 2013-03-17 20:36:00 +1100, 0:28:59
    385378200: Good Game, 2013-03-19 20:30:00 +1100, 0:32:59
    
Rename a single entry based on recording id
-----------------------------------------------

    eyetvtool -i 385118221 -u 'Good Game Spawn Point'
    2013-03-22 15:13:38.833 eyetvtool[3680:903] RECORDINGS

    385118221: Good Game Spawn Point, 2013-03-16 20:17:01 +1100, 0:17:58

    2013-03-22 15:13:39.023 eyetvtool[3680:903] PROGRAMS

eyetvtool does not know that there are no programs with the ID 385118221 so displays the PROGRAMS heading.

Rename all recordings based on their name
-----------------------------------------

    eyetvtool -t SP -R -u 'Good Game Spawn Point'
    2013-03-22 15:15:29.892 eyetvtool[3685:903] RECORDINGS

    385030980: Good Game Spawn Point, 2013-03-15 20:03:00 +1100, 0:29:59
    385077840: Good Game Spawn Point, 2013-03-16 09:04:00 +1100, 0:28:59
    385114800: Good Game Spawn Point, 2013-03-16 19:20:00 +1100, 0:28:58
    385173180: Good Game Spawn Point, 2013-03-17 11:33:00 +1100, 0:29:58
    385205760: Good Game Spawn Point, 2013-03-17 20:36:00 +1100, 0:28:59

