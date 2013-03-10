//
//  EyeTV.m
//  eyetvtool
//
//  Created by Mark Heath on 8/03/13.
//  Copyright (c) 2013 Mark Heath. All rights reserved.
//

#import "EyeTV.h"

@implementation EyeTV

- (NSAppleEventDescriptor *)makeQuery:(OSType)seld
{

    NSAppleEventDescriptor *obj = [NSAppleEventDescriptor recordDescriptor];
    NSAppleEventDescriptor *from = [NSAppleEventDescriptor recordDescriptor];

    [from setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'ID  '] forKeyword:'form'];
    [from setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:self->type] forKeyword:'want'];
    [from setParamDescriptor:[NSAppleEventDescriptor descriptorWithInt32:[self->uniqueID int32Value]] forKeyword:'seld'];
    [from setParamDescriptor:[NSAppleEventDescriptor nullDescriptor] forKeyword:'from'];

    
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'prop'] forKeyword:'form'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:'prop'] forKeyword:'want'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:seld] forKeyword:'seld'];
    [obj setParamDescriptor:[from coerceToDescriptorType:'obj '] forKeyword:'from'];
    
    return obj;

}

- (NSAppleEventDescriptor *)sendQuery:(OSType)prop
{

    NSAppleEventDescriptor *q = [self makeQuery:prop];
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'getd'
                                                                  targetDescriptor:self->eyetv
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];

    [evt setDescriptor:[q coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];

    AEDesc aeres;
    AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
    
    return [res paramDescriptorForKeyword:keyDirectObject];

}


- (NSString *)getText:(OSType)prop
{
    return [[self sendQuery:prop] stringValue];
}

+ (id)program
{
    return [[self alloc] initProgram];
}


- (id)initProgram
{

    self->eyetv = [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplSignature bytes:"VTyE" length:4];
    self->type = 'cPrg';
  
    NSAppleEventDescriptor *programData = [NSAppleEventDescriptor recordDescriptor];
    [programData setParamDescriptor:[NSAppleEventDescriptor descriptorWithBoolean:FALSE] forKeyword:'enbl'];

    NSAppleEventDescriptor *new = [NSAppleEventDescriptor recordDescriptor];
    [new setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:self->type] forKeyword:'kocl'];
    [new setParamDescriptor:programData forKeyword:'prdt'];

    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'crel'
                                                                  targetDescriptor:self->eyetv
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];

    [evt setDescriptor:[new coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];

     NSLog(@"event: %@",evt);

    
    AEDesc aeres;
    OSErr err=  AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    if (err != noErr) {
		return nil;
	}
    
    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
    
    NSLog(@"res: %@",res);

    
    // self->uniqueID = [res paramDescriptorForKeyword:keyDirectObject];
 
    return self;
}

+ (id)programWithID:(NSAppleEventDescriptor *)uniq
{
    return [[self alloc] initProgramWithID:uniq];
}

- (id)initProgramWithID:(NSAppleEventDescriptor *)uniq
{
    return [self initWithID:uniq type:'cPrg'];
}


+ (id)recordingWithID:(NSAppleEventDescriptor *)uniq
{
    return [[self alloc] initRecordingWithID:uniq];
}

- (id)initRecordingWithID:(NSAppleEventDescriptor *)uniq
{
   return [self initWithID:uniq type:'cRec'];
}

- (id)initWithID:(NSAppleEventDescriptor *)uniq type:(OSType)t
{
    self->eyetv = [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplSignature bytes:"VTyE" length:4];
    self->type = t;
    self->uniqueID = uniq;
    
    NSAppleEventDescriptor *get = [self makeQuery:'Unqu'];
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'getd'
                                                                  targetDescriptor:self->eyetv
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];
    
    [evt setDescriptor:[get coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];
    
   //  NSLog(@"event: %@",evt);
    
    AEDesc aeres;
    OSErr err=  AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    if (err != noErr) {
		return nil;
	}

    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
    
    self->uniqueID = [res paramDescriptorForKeyword:keyDirectObject];

    //   NSLog(@"res: %@",res);
    
    return self;
    
}



- (BOOL)matchTitle:(NSString *)match
{
  
    if (match == nil)
        return TRUE;
    
    NSString *title = [self getTitle];
  
    NSRange range = [title rangeOfString:match];
    
    return  range.location != NSNotFound;
    
}

- (BOOL)matchID:(NSString *)match
{
    
    if (match == nil)
        return TRUE;
    
    int id = [self->uniqueID int32Value];
    
    NSArray *matchArray = [match componentsSeparatedByString:@"-"];
    int fromID = [[matchArray objectAtIndex:0] intValue];

    int toID;
    if ([matchArray count] > 1)
    {
        toID = [[matchArray objectAtIndex:1] intValue];
    } else {
        toID = fromID;
    }
    

    return ((fromID <= id) && (toID >= id));
    
}

- (int)getUniqueID
{
    return [self->uniqueID int32Value];
}


- (NSString *)getTitle
{
    return [self getText:'Titl'];
}

- (NSString *)getDescription
{
    return [self getText:'Pdsc'];
}

- (NSDate *)getDate:(OSType)prop
{
    
    NSDate *resultDate = nil;
    CFAbsoluteTime absoluteTime;
    LongDateTime longDateTime;
    
    NSAppleEventDescriptor *aeDate = [self sendQuery:prop];
    
    [[aeDate data] getBytes:&longDateTime length:sizeof(longDateTime)];
    
    OSStatus status = UCConvertLongDateTimeToCFAbsoluteTime(longDateTime, &absoluteTime);
    
    if (status == noErr) {
        CFDateRef dt = CFDateCreate(NULL, absoluteTime);
        resultDate = (NSDate *)CFBridgingRelease(dt);
    }
    
    return resultDate;
}


- (NSDate *)getStartDate
{
    return [self getDate:'Acst'];
}

- (NSDate *)getStart
{
    return [self getDate:'Stim'];
}

- (int)getDuration
{
    return [[self sendQuery:'Dura'] int32Value];
}



+ (NSArray *)getRecordingList
{
    return [EyeTV getListFromType:'cRec'];
}

+ (NSArray *)getProgramList
{
    return [EyeTV getListFromType:'cPrg'];
}

+ (NSArray *)getListFromType:(OSType)etvType
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    
   NSAppleEventDescriptor * eyetv = [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplSignature bytes:"VTyE" length:4];
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'getd'
                                                                  targetDescriptor:eyetv
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];

    NSAppleEventDescriptor *obj = [NSAppleEventDescriptor recordDescriptor];
    
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'indx'] forKeyword:'form'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:etvType] forKeyword:'want'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithDescriptorType:'abso' bytes:" lla" length:4] forKeyword:'seld'];
    
    [obj setParamDescriptor:[NSAppleEventDescriptor nullDescriptor] forKeyword:'from'];
    
    [evt setDescriptor:[obj coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];
    
    // NSLog(@"event: %@",evt);
    
    AEDesc aeres;
    AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);

    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];

   // NSLog(@"res: %@",res);

    NSAppleEventDescriptor *recordlist = [res paramDescriptorForKeyword:keyDirectObject];

    int index = 1;
    
    NSAppleEventDescriptor *record;
    while ((record = [recordlist descriptorAtIndex:index++]) != nil)
    {
    //    NSLog(@"rec: %d",[[record descriptorForKeyword:'seld'] int32Value]);
        [list addObject:[record descriptorForKeyword:'seld']];
    }
    
     [list sortUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 int32Value] > [obj2 int32Value]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 int32Value] < [obj2 int32Value]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    return list;
}



@end
