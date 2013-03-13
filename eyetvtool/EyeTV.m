//
//  EyeTV.m
//  eyetvtool
//
//  Created by Mark Heath on 8/03/13.
//  Copyright (c) 2013 Mark Heath. All rights reserved.
//

#import "EyeTV.h"

@implementation EyeTV

- (NSAppleEventDescriptor *)getType
{
    return self->type;
}

- (void)setType:(OSType)t
{
    self->type = [NSAppleEventDescriptor descriptorWithTypeCode:t];
}

- (NSAppleEventDescriptor *)getApplication
{
    return self->eyetv;
}

- (NSAppleEventDescriptor *)getID
{
    return self->uniqueID;
}

- (void)setID:(NSAppleEventDescriptor *)id
{
    self->uniqueID = id;
}

- (NSAppleEventDescriptor *)makeQuery:(OSType)seld
{

    /*
    NSLog(@"seld: %d",seld);
    NSLog(@"type: %@",[self getType]);
    NSLog(@"ID: %@",[self getID]);
    */
    
    NSAppleEventDescriptor *obj = [NSAppleEventDescriptor recordDescriptor];
    
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'prop'] forKeyword:'form'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:'prop'] forKeyword:'want'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:seld] forKeyword:'seld'];
    [obj setParamDescriptor:[[self currentObject] coerceToDescriptorType:'obj '] forKeyword:'from'];
    
    return obj;

}

- (NSAppleEventDescriptor *)sendQuery:(OSType)prop
{

    NSAppleEventDescriptor *q = [self makeQuery:prop];
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'getd'
                                                                  targetDescriptor:[self getApplication]
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];

    [evt setDescriptor:[q coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];

    AEDesc aeres;
    AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    NSAppleEventDescriptor *res =  [[[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres] autorelease];
    
    return [res paramDescriptorForKeyword:keyDirectObject];

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
        resultDate =(NSDate *)dt;
      //  CFRelease(dt);

    }
    
    [resultDate autorelease];
    
    return resultDate;
}

- (NSString *)getText:(OSType)prop
{
    return [[self sendQuery:prop] stringValue];
}



+ (id)program
{
    return [[[self alloc] initProgram] autorelease];
}


- (id)initProgram
{

    self = [self init];
    self->eyetv = [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplSignature bytes:"VTyE" length:4];
    [self setType:'cPrg'];
  
    NSAppleEventDescriptor *programData = [NSAppleEventDescriptor recordDescriptor];
 // the program is enabled by default and will begin recording immediately.
    [programData setParamDescriptor:[NSAppleEventDescriptor descriptorWithBoolean:FALSE] forKeyword:'enbl'];

    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'crel'
                                                                  targetDescriptor:[self getApplication]
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];

    
    [evt setParamDescriptor:[self getType] forKeyword:'kocl'];
    [evt setParamDescriptor:programData forKeyword:'prdt'];

  //   NSLog(@"event: %@",evt);

    
    AEDesc aeres;
    OSErr err=  AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    if (err != noErr) {
        [self release];
		return nil;
	}
    
    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
    
 //  NSLog(@"res direct object for seld: %@");

  [self setID:[[res paramDescriptorForKeyword:keyDirectObject] paramDescriptorForKeyword:'seld']];
    
    // self->uniqueID = [res paramDescriptorForKeyword:keyDirectObject];
    [res release];
    return self;
}

+ (id)programWithID:(NSAppleEventDescriptor *)uniq
{
    return [[[self alloc] initProgramWithID:uniq] autorelease];
}

- (id)initProgramWithID:(NSAppleEventDescriptor *)uniq
{
    return [self initWithID:uniq type:'cPrg'];
}


+ (id)recordingWithID:(NSAppleEventDescriptor *)uniq
{
    return [[[self alloc] initRecordingWithID:uniq] autorelease];
}

- (id)initRecordingWithID:(NSAppleEventDescriptor *)uniq
{
   return [self initWithID:uniq type:'cRec'];
}

- (id)initWithID:(NSAppleEventDescriptor *)uniq type:(OSType)t
{
    
    self = [self init];
    
    self->eyetv = [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplSignature bytes:"VTyE" length:4];
    self->type = [NSAppleEventDescriptor descriptorWithTypeCode:t];
    self->uniqueID = uniq;
    
    NSAppleEventDescriptor *get = [self makeQuery:'Unqu'];
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'getd'
                                                                  targetDescriptor:[self getApplication]
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];
    
    [evt setDescriptor:[get coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];
    
   //  NSLog(@"event: %@",evt);
    
    AEDesc aeres;
    OSErr err=  AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    if (err != noErr) {
        [self release];
		return nil;
	}

    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
    
    self->uniqueID = [res paramDescriptorForKeyword:keyDirectObject];

    [res release];
    
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
    
    int id = [self getUniqueID];
    
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
    return [[self getID] int32Value];
}


- (NSString *)getTitle
{
    return [self getText:'Titl'];
}

- (NSString *)getDescription
{
    return [self getText:'Pdsc'];
}



- (NSDate *)getActualStart
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


- (NSString *)secToString:(int)seconds
{
    int hour = seconds / 3600;
	int min = (seconds % 3600) / 60;
	int sec = seconds % 60;

    return [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,sec];
    
}

- (NSString *)getDurationAsString
{
    return [self secToString:[self getDuration]];
}

- (int)getActualDuration
{
    return [[self sendQuery:'Acdu'] int32Value];
}

- (NSString *)getActualDurationAsString
{
    return [self secToString:[[self sendQuery:'Acdu'] int32Value]];
}

- (NSString *)getEpisode
{
    return [self getText:'Epis'];
}

- (BOOL)isBusy
{
    return [[self sendQuery:'RTsk'] booleanValue];
}

- (int)getChannelNumber
{
    
    NSAppleEventDescriptor  *channel = [self sendQuery:'Chnm'];
   // NSLog(@"channel: %@",channel);
    
    return [channel int32Value];
}

- (NSString *)getChannelName
{
    return [self getText:'Stnm'];
}

// should make this a map
- (OSType)stringToRepeat:(NSString *)s
{

    if ([s compare:@"Daily"]==0) return EyeTVRptsDaily;
    if ([s compare:@"Friday"]==0) return EyeTVRptsFriday;
    if ([s compare:@"Monday"]==0) return EyeTVRptsMonday;
    if ([s compare:@"Never"]==0) return EyeTVRptsNever;
    if ([s compare:@"None"]==0) return EyeTVRptsNone;
    if ([s compare:@"Saturday"]==0) return EyeTVRptsSaturday;
    if ([s compare:@"Sunday"]==0) return EyeTVRptsSunday;
    if ([s compare:@"Thursday"]==0) return EyeTVRptsThursday;
    if ([s compare:@"Tuesday"]==0) return EyeTVRptsTuesday;
    if ([s compare:@"Wednesday"]==0) return EyeTVRptsWednesday;
    if ([s compare:@"Weekdays"]==0) return EyeTVRptsWeekdays;
    if ([s compare:@"Weekends"]==0) return EyeTVRptsWeekends;

    return EyeTVRptsNone;

}

- (NSString *)repeatToString:(OSType)repeat
{
    switch(repeat)
    {
        case EyeTVRptsDaily: return @"Daily"; break;
        case EyeTVRptsFriday: return @"Friday"; break;
        case EyeTVRptsMonday: return @"Monday"; break;
        case EyeTVRptsNever: return @"Never"; break;
        case EyeTVRptsNone: return @"None"; break;
        case EyeTVRptsSaturday: return @"Saturday"; break;
        case EyeTVRptsSunday: return @"Sunday"; break;
        case EyeTVRptsThursday: return @"Thursday"; break;
        case EyeTVRptsTuesday: return @"Tuesday"; break;
        case EyeTVRptsWednesday: return @"Wednesday"; break;
        case EyeTVRptsWeekdays: return @"Weekdays"; break;
        case EyeTVRptsWeekends: return @"Weekends"; break;
        default: return nil;
    }
}

- (NSAppleEventDescriptor *)getRepeats
{
    return [self sendQuery:'Rpts'];
}

- (NSString *)getRepeatsAsString
{
  //  NSLog(@"Repeats: %@",rpt);
    
    NSAppleEventDescriptor *rpt = [self getRepeats];

    NSMutableString *repeats = [[[NSMutableString alloc] initWithCapacity:4] autorelease];

    int count =1;
    NSAppleEventDescriptor *item;

    while ((item = [rpt descriptorAtIndex:count++]) != nil)
    {
        if (count > 2)
            [repeats appendString:@";"];
        
        [repeats appendString:[self repeatToString:[item enumCodeValue]]];
    }
    
    
    return repeats;
    
}

- (BOOL)getEnabled
{
    return [[self sendQuery:'enbl'] booleanValue];
}



- (void)setProp:(OSType)prop value:(NSAppleEventDescriptor *)val

{
    
    NSAppleEventDescriptor  *obj = [NSAppleEventDescriptor recordDescriptor];
    
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'prop'] forKeyword:'form'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:'prop'] forKeyword:'want'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:prop] forKeyword:'seld'];
    [obj setParamDescriptor:[[self currentObject] coerceToDescriptorType:'obj '] forKeyword:'from'];
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'setd'
                                                                  targetDescriptor:[self getApplication]
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];
    [evt setParamDescriptor:val forKeyword:'data'];
    [evt setDescriptor:[obj coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];
    
//   NSLog(@"event: %@",evt);
    
    
    AEDesc aeres;
  OSErr err =   AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    if (err != noErr)
    {
        NSAppleEventDescriptor *res = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
        NSLog(@"Error Setting Property: %@",res);
    }
    
    // there shouldn't be a response
}
    
- (void)setTitle:(NSString *)s
{
    [self setProp:'Titl' value:[NSAppleEventDescriptor descriptorWithString:s]];
}

-(void)setDuration:(int)d
{
    
    [self setProp:'Dura' value:[NSAppleEventDescriptor descriptorWithInt32:d]];
}


- (void)setChannelNumber:(int)ch
{
    [self setProp:'Chnm' value:[NSAppleEventDescriptor descriptorWithInt32:ch]];

}

- (void)setStart:(NSDate *)date
{
 
    
  //  NSLog(@"Date: %@",date);
    
	// Get the time interval since 1st Jan 2001 of the date
	CFAbsoluteTime timeInterval = CFDateGetAbsoluteTime((CFDateRef)date);
    
	// Convert the time interval to a long date
	LongDateTime longDate;
	UCConvertCFAbsoluteTimeToLongDateTime(timeInterval, &longDate);
    
	// Build the descriptor
    [self setProp:'Stim' value:[NSAppleEventDescriptor descriptorWithDescriptorType:'ldt ' bytes:&longDate length:sizeof(longDate)]];
                                                                                                   
}

- (void)setStartWithString:(NSString *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
  //  NSLog(@"String Date: %@",date);
    
    NSDate *myDate = [df dateFromString:date];

    [self setStart:myDate];
    
    [df release];
}

-(void)setRepeatsWithString:(NSString *)rpt
{
    
    
    NSEnumerator *e = [[rpt componentsSeparatedByString:@","] objectEnumerator];
    
    NSAppleEventDescriptor *repeats = [NSAppleEventDescriptor listDescriptor];
    
    id object;
    while (object = [e nextObject]) {
        [repeats insertDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:[self stringToRepeat:object]] atIndex:0];
    }
    
    NSLog(@"repeats %@",repeats);
    
    [self setProp:'Rpts' value:repeats];

}

- (void)setEnableDisable:(BOOL)enable
{
    [self setProp:'enbl' value:[NSAppleEventDescriptor descriptorWithBoolean:enable]];
}

- (void)setEnabled
{
    [self setEnableDisable:TRUE];
}

- (void)setDisabled
{
    [self setEnableDisable:FALSE];
}

- (NSAppleEventDescriptor *)currentObject
{
    NSAppleEventDescriptor  *from = [NSAppleEventDescriptor recordDescriptor];
    
    [from setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'ID  '] forKeyword:'form'];
    [from setParamDescriptor:[self getType] forKeyword:'want'];
    [from setParamDescriptor:[self getID] forKeyword:'seld'];
    [from setParamDescriptor:[NSAppleEventDescriptor nullDescriptor] forKeyword:'from'];

    return from;
}

-(void)exportToPath:(NSString *)path withFormat:(OSType)format
{


    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'EyTV'
                                                                           eventID:'Expo'
                                                                  targetDescriptor:[self getApplication]
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];

    
    [evt setParamDescriptor:[[self currentObject] coerceToDescriptorType:'obj '] forKeyword:'Esrc' ];
    [evt setParamDescriptor:[NSAppleEventDescriptor descriptorWithString:path] forKeyword:'Etgt'];
    [evt setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:format] forKeyword:'Etyp'];
    [evt setParamDescriptor:[NSAppleEventDescriptor descriptorWithBoolean:TRUE] forKeyword:'Repl'];
    [evt setParamDescriptor:[NSAppleEventDescriptor descriptorWithBoolean:FALSE] forKeyword:'Opng'];
    
    
   // [evt setDescriptor:[query coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];
    
    [self setInteractionOff];
        
    
    AEDesc aeres;
    
    OSErr err =   AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    NSAppleEventDescriptor *res = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];

    if (err != noErr)
    {
        NSLog(@"Error Exporting: %@",res);
    }

    while ([self isBusy])
    {
        printf("."); fflush(stdout);
        sleep(1);
    }
    printf("\n");

    [self setInteractionOn];

    // should check for errors.
}

-(void)remove
{

    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'delo'
                                                                  targetDescriptor:[self getApplication]
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];
    
    [evt setDescriptor:[[self currentObject] coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];
    
   // NSLog(@"event: %@",evt);
    
    
    AEDesc aeres;
    
    // ARE YOU SURE ?
    OSErr err =   AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    if (err != noErr)
    {
        NSAppleEventDescriptor *res = [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
        NSLog(@"Error Deleting: %@",res);
    }
    
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
    OSErr err = AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);

    
    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];

    if (err != noErr)
    {
        NSLog(@"Error getting List: %@",res);
        return nil;
    }
    

   // NSLog(@"res: %@",res);

    NSAppleEventDescriptor *recordlist = [res paramDescriptorForKeyword:keyDirectObject];

    int index = 1;
    
    NSAppleEventDescriptor *record;
    while ((record = [recordlist descriptorAtIndex:index++]) != nil)
    {
    //    NSLog(@"rec: %d",[[record descriptorForKeyword:'seld'] int32Value]);
        [list addObject:[record descriptorForKeyword:'seld']];
    }
    
    // TODO: sort list. sortUsingComparator is a newly added method.
    
    [res release];
    
   // [list sortUsingSelector:@selector(compare:)];
    /*
     [list sortUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 int32Value] > [obj2 int32Value]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 int32Value] < [obj2 int32Value]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
*/
    return list;
     
}

- (void)setInteraction:(OSType)i
{
    
    NSAppleEventDescriptor *evt = [NSAppleEventDescriptor appleEventWithEventClass:'core'
                                                                           eventID:'setd'
                                                                  targetDescriptor:eyetv
                                                                          returnID:kAutoGenerateReturnID
                                                                     transactionID:kAnyTransactionID];
    
    NSAppleEventDescriptor *obj = [NSAppleEventDescriptor recordDescriptor];
    
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:'prop'] forKeyword:'form'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:'prop'] forKeyword:'want'];
    [obj setParamDescriptor:[NSAppleEventDescriptor descriptorWithTypeCode:'eInl'] forKeyword:'seld'];
    [obj setParamDescriptor:[NSAppleEventDescriptor nullDescriptor] forKeyword:'from'];
    
    [evt setParamDescriptor:[NSAppleEventDescriptor descriptorWithEnumCode:i] forKeyword:'data'];

    
    [evt setDescriptor:[obj coerceToDescriptorType:'obj '] forKeyword:keyDirectObject];

    AEDesc aeres;
    OSErr err = AESendMessage([evt aeDesc], &aeres,  kAEWaitReply | kAENeverInteract, kAEDefaultTimeout);
    
    
    NSAppleEventDescriptor *res =  [[NSAppleEventDescriptor alloc] initWithAEDescNoCopy:&aeres];
    
    if (err != noErr)
    {
        NSLog(@"Error setting interactivity: %@",res);
    }

    [res release];
    
}

- (void) setInteractionOn
{
    [self setInteraction:'eInA'];
}

- (void) setInteractionOff
{
    [self setInteraction:'eNvr'];
}


@end
