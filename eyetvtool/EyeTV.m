//
//  EyeTV.m
//  eyetvtool
//
//  Created by Mark Heath on 8/03/13.
//  Copyright (c) 2013 Mark Heath. All rights reserved.
//

#import "EyeTV.h"

@implementation EyeTV

+ (NSArray *)getListFromType:(OSType)etvType
{
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:1];
    
    NSAppleEventDescriptor* eyetv =
    [NSAppleEventDescriptor descriptorWithDescriptorType:typeApplSignature bytes:"VTyE" length:4];

    
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
    
    
    return list;
}



@end
