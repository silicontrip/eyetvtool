#import <Cocoa/Cocoa.h>

@interface Arguments: NSObject {
	NSMutableDictionary *opt;
	NSMutableArray *arg;
}

- (id)initWithNSProcessInfoArguments:(NSArray *)a;
- (NSArray *)getArguments;
- (NSDictionary *)getOptions;
- (NSString *) description;
- (NSString *) addArg:(NSString *)old:(NSString *)new:(bool *)end;
- (BOOL)hasArgument:(NSString *)s;
- (BOOL)containsArgument:(NSString *)s;
- (id)optionForKey:(NSString *)s;



@end
