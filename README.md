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
