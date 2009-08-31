
#import <Cocoa/Cocoa.h>


@interface FeedMessageList : NSObject {
  NSMutableArray* messages;
}

@property (nonatomic, retain) NSMutableArray* messages;


- (void)processMessages:(NSMutableDictionary*)messageDictionary;

@end
