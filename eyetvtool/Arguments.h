#import <Cocoa/Cocoa.h>

@interface Arguments: NSObject {
	NSMutableDictionary *opt;
	NSMutableArray *arg;
}

- (id)initWithNSProcessInfoArguments:(NSArray *)a;
- (NSArray *)getArguments;
- (NSDictionary *)getOptions;
- (NSString *) description;
- (NSString *) addArgOld:(NSString *)old New:(NSString *)new End:(bool *)end;
- (BOOL)hasArgument:(NSString *)s;
- (BOOL)containsArgument:(NSString *)s;
- (id)optionForKey:(NSString *)s;
- (id)optionForShortKey:(NSString *)shortKey LongKey:(NSString *)longKey;



@end
