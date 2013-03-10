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
        
        
        
        NSString *match_id = nil;
        if ([newargs hasArgument:@"i"])
            match_id = [newargs optionForKey:@"i"];
        
        if ([newargs hasArgument:@"id"])
            match_id = [newargs optionForKey:@"id"];

        NSString *set_title = nil;
        if ([newargs hasArgument:@"u"])
            set_title = [newargs optionForKey:@"u"];
        if ([newargs hasArgument:@"settitle"])
            set_title = [newargs optionForKey:@"settitle"];

        NSString *set_channel = nil;
        if ([newargs hasArgument:@"C"])
            set_channel = [newargs optionForKey:@"C"];
        if ([newargs hasArgument:@"channel"])
            set_channel = [newargs optionForKey:@"channel"];

        NSString *set_start = nil;
        if ([newargs hasArgument:@"s"])
            set_channel = [newargs optionForKey:@"s"];
        if ([newargs hasArgument:@"start"])
            set_channel = [newargs optionForKey:@"start"];

        
        if ([newargs hasArgument:@"n"] || [newargs hasArgument:@"new"]) {
         
            NSLog(@"NEW Program");
            
            EyeTV *rec = [EyeTV program];
            
                        //WithTitle:set_title channel:set_channel startsAt:set_start duration:set_duration];
            
        } else {
            if (![newargs hasArgument:@"P"] && ![newargs hasArgument:@"programs"]) {
        
            NSLog(@"RECORDINGS");

            NSEnumerator *e = [[EyeTV getRecordingList] objectEnumerator];
            id object;
            while (object = [e nextObject]) {
                // do something with object
                
                
                EyeTV *rec = [EyeTV recordingWithID:object];
                
                if ([rec matchID:match_id])
                    printf("%d: %s, %s, %s, %d\n",[rec getUniqueID],
                           [[rec getTitle] UTF8String],
                           [[[rec getStartDate] description] UTF8String],
                           [[[rec getStart] description]UTF8String],
                           [rec getDuration]);
                
                [rec getDuration];
                [rec getStart];
 
            }

            
        }
            if (![newargs hasArgument:@"R"] && ![newargs hasArgument:@"recordings"]) {
        
            NSLog(@"PROGRAMS");
            
            NSEnumerator *e = [[EyeTV getProgramList] objectEnumerator];
            id object;
            while (object = [e nextObject]) {
                // do something with object
                
                
                EyeTV *rec = [EyeTV programWithID:object];
                
                if ([rec matchID:match_id])
                    printf("%d: %s\n",[rec getUniqueID],[[rec getTitle] UTF8String]);
                
            }

            
        }
        }
    }
    return 0;
}

