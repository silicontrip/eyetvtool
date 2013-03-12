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
        
        BOOL action_export = [newargs hasArgument:@"export"];
        BOOL action_remove = [newargs hasArgument:@"delete"];
        BOOL set_enabled = [newargs hasArgument:@"enable"] || [newargs hasArgument:@"E"];
        BOOL set_disabled = [newargs hasArgument:@"disable"] || [newargs hasArgument:@"D"];
        BOOL i_am_sure = [newargs hasArgument:@"yes"] || [newargs hasArgument:@"Y"];
        
        NSString *match_id = [newargs optionForShortKey:@"i" LongKey:@"id"];
        NSString *match_title = [newargs optionForShortKey:@"t" LongKey:@"title"];
        NSString *set_title = [newargs optionForShortKey:@"u" LongKey:@"settitle"];
        NSString *set_duration = [newargs optionForShortKey:@"l" LongKey:@"length"];
        NSString *set_repeats = [newargs optionForShortKey:@"p" LongKey:@"repeats"];
        NSString *set_channel = [newargs optionForShortKey:@"C" LongKey:@"channel"];
        NSString *set_start = [newargs optionForShortKey:@"s" LongKey:@"start"];
        
        
        
        
        if ([newargs hasArgument:@"n"] || [newargs hasArgument:@"new"]) {
            
            NSLog(@"NEW Program");
            
            EyeTV *rec = [EyeTV program];
            
            while ([rec isBusy])
                sleep (1);
            
            if (set_title != nil)
                [rec setTitle:set_title];

            if (set_duration != nil)
                [rec setDuration:[set_duration integerValue]];
            
            if (set_repeats != nil)
                [rec setRepeatsWithString:set_repeats];
            
            if (set_start != nil)
                [rec setStartWithString:set_start];
            
            if (set_enabled)
                [rec setEnabled];
                        
            if (set_channel!=nil)
                [rec setChannelNumber:[set_channel integerValue]];

            printf("%d: %s, %s, %s, %d, %s, %s, %d\n",[rec getUniqueID],
                   [[rec getTitle] UTF8String],
                   [[[rec getStart] description] UTF8String],
                   [[rec getDurationAsString] UTF8String],
                   [rec getChannelNumber],
                   [[rec getChannelName] UTF8String],
                   [[rec getRepeatsAsString] UTF8String],
                   [rec getEnabled]);

            
            //WithTitle:set_title channel:set_channel startsAt:set_start duration:set_duration];
            
        } else {
            
            if ((!match_id && !match_title) && (action_export || action_remove || set_start || set_title || set_duration || set_repeats || set_channel || set_enabled || set_disabled) && !i_am_sure)
            {
                printf ("No recordings or programs selected for action\n");
                printf ("if you're sure add -Y\n");
                exit(0);
                
            }

            
            if (![newargs hasArgument:@"P"] && ![newargs hasArgument:@"programs"]) {
                
                NSLog(@"RECORDINGS");
                
                NSEnumerator *e = [[EyeTV getRecordingList] objectEnumerator];
                id object;
                while (object = [e nextObject]) {
                    // do something with object
                    
                    
                    EyeTV *rec = [EyeTV recordingWithID:object];
                    
                    if ([rec matchID:match_id] && [rec matchTitle:match_title]) {
                        
                        if (set_title != nil)
                            [rec setTitle:set_title];
                        
                        printf("%d: %s, %s, %s\n",[rec getUniqueID],
                               [[rec getTitle] UTF8String],
                               [[[rec getActualStart] description] UTF8String],
                               [[rec getActualDurationAsString] UTF8String]);
                        
                        if (action_export)
                        {
                            // export me baby
                        }
                        if (action_remove)
                            [rec remove];
                        
                    }
                }
                
                
            }
            if (![newargs hasArgument:@"R"] && ![newargs hasArgument:@"recordings"]) {
                
                NSLog(@"PROGRAMS");
                
                NSEnumerator *e = [[EyeTV getProgramList] objectEnumerator];
                id object;
                while (object = [e nextObject]) {
                    // do something with object
                    
                    
                    EyeTV *rec = [EyeTV programWithID:object];
                    
                    // NSLog(@"obj: %@",object);
                    
                    if ([rec matchID:match_id] && [rec matchTitle:match_title])
                    {
                        if ([[EyeTV recordingWithID:object] getID] == nil) {
                            
                            if (set_title != nil)
                                [rec setTitle:set_title];
                            
                            if (set_duration != nil)
                                [rec setDuration:[set_duration integerValue]];
                            
                            if (set_repeats != nil)
                                [rec setRepeatsWithString:set_repeats];
                            
                            if (set_start != nil)
                                [rec setStartWithString:set_start];
                            
                            if (set_enabled)
                                [rec setEnabled];
                            
                            if (set_disabled)
                                [rec setDisabled];
                            
                            if (set_channel!=nil)
                                [rec setChannelNumber:[set_channel integerValue]];
                            
                            
                            printf("%d: %s, %s, %s, %d, %s, %s, %d\n",[rec getUniqueID],
                                   [[rec getTitle] UTF8String],
                                   [[[rec getStart] description] UTF8String],
                                   [[rec getDurationAsString] UTF8String],
                                   [rec getChannelNumber],
                                   [[rec getChannelName] UTF8String],
                                   [[rec getRepeatsAsString] UTF8String],
                                   [rec getEnabled]
                                );
                            
                            if (action_remove)
                                [rec remove];

                        }
                    }
                }
                
                
            }
        }
    }
    return 0;
}

