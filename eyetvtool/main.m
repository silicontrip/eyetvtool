//
//  main.m
//  eyetvtool
//
//  Created by Mark Heath on 8/03/13.
//  Copyright (c) 2013 Mark Heath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EyeTV.h"
#import "Arguments.h"

void usage()
{

    printf ("Eye TV Tool.  A command line interface for controlling the Eye TV PVR software.\n");
    printf ("Usage etvtool.pl [OPTION]\n\n");
    printf ("Actions:\n");
    printf ("--export     Export selected recordings\n");
    printf ("--delete     Delete selected recordings or programs\n");
    printf ("-n --new     Create a new program\n");
    printf ("-E --enable  Enable a program\n");
    printf ("-D --disable Disable a program\n");
    printf ("-h --help    This help\n");
    printf ("\nSelecting programs and recordings:\n");
    printf ("If nothing is selected here, every program and recording is selected.\n");
    printf ("-t --title <title> Select matching sub string\n");
    printf ("-i --id <id>       Select matching id.  id can be a range eg 1234-1245\n");
    printf ("-Y --yes           Allow actions on every program and recording\n");
    printf ("-R --recordings    Select only recordings\n");
    printf ("-P --programs      Select only programs\n");
    printf ("\nSet program data:\n");
    printf ("-s --start <YYYY-MM-DD HH:MM:SS> Set start time of a program\n");
    printf ("-u --settitle <title>            Set the title of a program or recording\n");
    printf ("-l --length <seconds>            Set the record duration of a program\n");
    printf ("-p --repeats <days>              Set the repeats of the program\n");
    printf ("             [None|Sund|Mond|Tues|Wedn|Thur|Frid|Satu|Week|Wknd|Dail] comma separated for multiple days\n");
    printf ("-C --channel <channel>           Set the channel number of the program\n");

}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        Arguments *newargs = [[Arguments alloc]  initWithNSProcessInfoArguments:[[NSProcessInfo processInfo] arguments]];
        
        if([newargs hasArgument:@"help"] || [newargs hasArgument:@"h"])
        {
            usage();
            exit(0);
        }

        // insert code here...

        if (![newargs hasArgument:@"P"] && ![newargs hasArgument:@"programs"]) {
        
            NSEnumerator *e = [[EyeTV getListFromType:'cRec'] objectEnumerator];
            id object;
            while (object = [e nextObject]) {
                // do something with object
                
                NSLog(@"REC: %@",object);
                
            }

            
        }
        
    }
    return 0;
}

