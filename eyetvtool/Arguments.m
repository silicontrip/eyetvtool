#import "Arguments.h"

@implementation Arguments

- (id)init
{
	self = [super init];

	opt = [[NSMutableDictionary alloc] init];
	arg = [[NSMutableArray alloc] init];

	return self;
}

- (NSString *) addArgOld:(NSString *)old New:(NSString *)new End:(bool *)end
{

	if (old) {
		if ([old compare:@"--"] == 0) 
			*end = true;
				
		if (*end) {
		//	NSLog(@"add %@ to argument array",old);
			//add to arguments array
			[arg addObject:old];
		} else if ([old hasPrefix:@"--"]) {
			if ([new hasPrefix:@"-"]) {
				//NSLog(@"add %@ to dict as true bool",old);
				// add old arg to dict as true bool	
				[opt setObject:[NSNumber numberWithBool:YES] forKey:[old substringFromIndex:2]];
			} else {
				//NSLog(@"add %@ to dict as string %@",old,new);
				// add old arg to dict as string
				[opt setObject:new forKey:[old substringFromIndex:2]];
				// need to skip parsing this option
				new = nil;
			}
		} else if ([old hasPrefix:@"-"]) {
			if ([new hasPrefix:@"-"]) {
				//NSLog(@"add each letter of %@ to dict as true bool",old);
				// add each letter of old arg to dict as true bool	
				int i;
				for (i=1; i < [old length]; i++) {
					NSString *letter  = [NSString stringWithFormat:@"%c", [old characterAtIndex:i]];
					[opt setObject:[NSNumber numberWithBool:YES] forKey:letter];
				}
			} else {
				//NSLog(@"add each letter excluding last latter of %@ to dict as true bool with last letter %@",old,new);

				// add each letter excluding last letter of old arg to dict as true bool	
				int i ;
				for (i=1; i < [old length]-1; i++) {
					NSString *letter  = [NSString stringWithFormat:@"%c", [old characterAtIndex:i]];
					[opt setObject:[NSNumber numberWithBool:YES] forKey:letter];
				}

				// add last letter of old arg to dict as string
				[opt setObject:new forKey:[old substringFromIndex:[old length]-1]];
				new = nil;
			}
		}  else {
			// add to argument array
			//NSLog(@"add %@ to argument array",old);
			[arg addObject:old];
		}
	}
	return new;
}

/* long arguments must begin with a -- (--long)
** short arguments can be combined. (-la)
** NOTE any non argument following an argument is assumed an option of that argument.  (-n 12)
** this could lead to potential issues with the remaining argument array.
** Any non arguments are added to an argument array 
** either the proceeding argument must have an option,  ( --long long_arg arg1 arg2 arg3)
** this will not work ( --long arg1 arg2 arg3) arg1 becomes the value of long
** or the non argument must come before the option ( arg1 arg2 arg3 --long)
** or they must be seperated by a -- (--long -- arg1 arg2 arg3)
*/

- (id)initWithNSProcessInfoArguments:(NSArray *)a
{
	self = [self init];
	// NSMutableArray *args = [NSMutableArray arrayWithCapacity:[a count]];
	NSString *oldArg = nil;
	bool endOfArguments = false;

	for (NSString *argument in a) 
	{

//		NSLog(@"old: %@ current: %@",oldArg,argument);
		oldArg = [self addArgOld:oldArg New:argument End:&endOfArguments];
	}


	[self addArgOld:oldArg New:@"--" End:&endOfArguments];

	return self;

}

- (BOOL)hasArgument:(NSString *)s {
    return [arg containsObject:s] || [opt objectForKey:s]!=nil;
}

- (BOOL)containsArgument:(NSString *)s
{
         return [arg containsObject:s];
}
- (id)optionForKey:(NSString *)s 
{
	return [opt objectForKey:s];
}

- (id)optionForShortKey:(NSString *)shortKey LongKey:(NSString *)longKey
{
    
    // not sure if I should check to see if both long key and short key are set
    
    if ([self optionForKey:shortKey] != nil)
        return [self optionForKey:shortKey];
    
    return [self optionForKey:longKey];

}

- (NSArray *)getArguments { return arg; }
- (NSDictionary *)getOptions { return opt; }

-(NSString *) description
{
    return [NSString stringWithFormat:@"<%@ %p>\n{arg: %@}\n{opt: %@}", [self class], self, [self getArguments], [self getOptions]];
}


@end
