
#import <Cocoa/Cocoa.h>


@interface FeedMessageList : NSObject {
  NSMutableArray* messages;
}

@property (nonatomic, retain) NSMutableArray* messages;


- (NSArray *)processMessages:(NSMutableDictionary*)dict;
+ (NSString*)safeName:(NSMutableDictionary*)dict;

@end
