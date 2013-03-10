//
//  EyeTV.h
//  eyetvtool
//
//  Created by Mark Heath on 8/03/13.
//  Copyright (c) 2013 Mark Heath. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import <AE/AEMach.h>

@interface EyeTV : NSObject
{
    NSAppleEventDescriptor *uniqueID;
    OSType type;
    NSAppleEventDescriptor* eyetv;
}

- (NSAppleEventDescriptor *)makeQuery:(OSType)seld;

+ (NSArray *)getRecordingList;
+ (NSArray *)getProgramList;
+ (NSArray *)getListFromType:(OSType)etvType;

+ (id)program;
- (id)initProgram;

- (id)initProgramWithID:(NSAppleEventDescriptor *)uniq;
+ (id)programWithID:(NSAppleEventDescriptor *)uniq;


- (id)initRecordingWithID:(NSAppleEventDescriptor *)uniq;
+ (id)recordingWithID:(NSAppleEventDescriptor *)uniq;

- (BOOL)matchTitle:(NSString *)match;
- (BOOL)matchID:(NSString *)match;

- (int)getUniqueID;
- (NSString *)getTitle;
- (NSDate *)getStartDate;
- (NSDate *)getStart;
- (int)getDuration;



@end
