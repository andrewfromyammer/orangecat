#import <Cocoa/Cocoa.h>


@interface OrangeCat : NSObject {
  IBOutlet NSWindow* window;
  NSTextField* authCode;
  IBOutlet id firstResponder;
  IBOutlet NSScrollView* scroll;
  IBOutlet NSTableView* table;
  IBOutlet NSCollectionView* collection;
  IBOutlet NSCollectionViewItem* collectionItem;
  IBOutlet NSArrayController *arrayController;
}

- (void)setupFeeds;
- (void)setupCode;
- (IBAction)doLogout:(id)sender;
+ (NSMutableDictionary *)getMyFeed;

@end
