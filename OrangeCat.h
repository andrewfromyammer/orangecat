#import <Cocoa/Cocoa.h>


@interface OrangeCat : NSObject {
  IBOutlet NSWindow* window;
  NSTextField* authCode;
  IBOutlet id firstResponder;
  IBOutlet NSScrollView* scroll;
  IBOutlet NSTableView* table;
}

- (void)setupFeeds;
- (IBAction)doLogout:(id)sender;
+ (NSMutableDictionary *)getMyFeed;

@end
