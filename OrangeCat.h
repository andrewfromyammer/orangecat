#import <Cocoa/Cocoa.h>
#import "FeedMessageList.h"

@interface OrangeCat : NSObject {
  IBOutlet NSWindow* window;
  NSTextField* authCode;
  IBOutlet id firstResponder;
  IBOutlet NSScrollView* scroll;
  IBOutlet NSTableView* table;
  IBOutlet NSCollectionView* collection;
  IBOutlet NSCollectionViewItem* collectionItem;
  IBOutlet NSArrayController *arrayController;
  
  FeedMessageList* data;
  NSNumber* last;
}

@property (nonatomic, retain) FeedMessageList* data;
@property (nonatomic, retain) NSNumber* last;

- (void)setupFeeds;
- (void)setupCode;
- (IBAction)doLogout:(id)sender;
+ (NSMutableDictionary *)getMyFeed;

@end
