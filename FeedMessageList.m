#import "FeedMessageList.h"

@implementation FeedMessageList


- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  return 10;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  return @"Wefwefwef";
}

@end
