//
//  EyeTV.h
//  eyetvtool
//
//  Created by Mark Heath on 8/03/13.
//  Copyright (c) 2013 Mark Heath. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import <AE/AEMach.h>

enum EyeTVRpts {
    EyeTVRptsMonday = 'Mond',
    EyeTVRptsTuesday = 'Tues',
    EyeTVRptsWednesday = 'Wedn',
    EyeTVRptsThursday = 'Thur',
    EyeTVRptsFriday = 'Frid',
    EyeTVRptsSaturday = 'Satu',
    EyeTVRptsSunday = 'Sund',
    EyeTVRptsNever = 'Neve',
    EyeTVRptsNone = 'None',
    EyeTVRptsDaily = 'Dail',
    EyeTVRptsWeekdays = 'Week',
    EyeTVRptsWeekends = 'Wknd'
};
typedef enum EyeTVRpts EyeTVRpts;


@interface EyeTV : NSObject
{
    NSAppleEventDescriptor *uniqueID;
    NSAppleEventDescriptor *type;
    NSAppleEventDescriptor *eyetv;
    NSAppleEventDescriptor *eyetvObject;
}

- (NSAppleEventDescriptor *)getType;
- (NSAppleEventDescriptor *)getApplication;
- (NSAppleEventDescriptor *)getID;
- (NSAppleEventDescriptor *)currentObject;
- (NSAppleEventDescriptor *)buildObject;

- (NSAppleEventDescriptor *)makeQuery:(OSType)seld;
- (NSAppleEventDescriptor *)sendQuery:(OSType)prop;

+ (NSArray *)getRecordingList;
+ (NSArray *)getProgramList;
+ (NSArray *)getListFromType:(OSType)etvType;

+ (id)program;
- (id)initProgram;
- (id)initWithID:(NSAppleEventDescriptor *)uniq type:(OSType)t;

- (id)initProgramWithID:(NSAppleEventDescriptor *)uniq;
+ (id)programWithID:(NSAppleEventDescriptor *)uniq;

- (id)initRecordingWithID:(NSAppleEventDescriptor *)uniq;
+ (id)recordingWithID:(NSAppleEventDescriptor *)uniq;

- (BOOL)matchTitle:(NSString *)match;
- (BOOL)matchID:(NSString *)match;

- (OSType)stringToRepeat:(NSString *)s;
- (NSString *)repeatToString:(OSType)repeat;
- (NSString *)secToString:(int)seconds;

- (int)getUniqueID;
- (NSString *)getTitle;
- (NSDate *)getActualStart;
- (NSDate *)getStart;
- (int)getDuration;
- (NSString *)getDurationAsString;
- (int)getActualDuration;
- (NSString *)getActualDurationAsString;
- (NSString *)getEpisode;
- (BOOL)isBusy;
- (int)getChannelNumber;
- (NSString *)getChannelName;
- (NSAppleEventDescriptor *)getRepeats;
- (NSString *)getRepeatsAsString;
- (BOOL)getEnabled;
- (NSString *)getEnabledAsString;
- (NSString *)getLocation;


- (void)setProp:(OSType)prop value:(NSAppleEventDescriptor *)val;
- (void)setTitle:(NSString *)s;
- (void)setDuration:(int)d;
- (void)setChannelNumber:(int)ch;
- (void)setStart:(NSDate *)date;
- (void)setStartWithString:(NSString *)date;
- (void)setRepeatsWithString:(NSString *)rpt;
- (void)setEnableDisable:(BOOL)enable;
- (void)setEnabled;
- (void)setDisabled;

- (void)exportToPath:(NSString *)path withFormat:(OSType)format;
- (void)remove;

- (void)setInteraction:(OSType)i;
- (void)setInteractionOn;
- (void)setInteractionOff;

- (NSString *)description;


@end
