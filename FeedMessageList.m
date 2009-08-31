#import "FeedMessageList.h"

@implementation FeedMessageList
@synthesize messages;

- (id)init {
  if (self = [super init]) {
    self.messages = [NSMutableArray array];
  }
  
  return self;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  if ([messages count] == 0)
    return 1;
  return [messages count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  if ([messages count] == 0)
    return @"Loading...";
  return @"ddd";
}

- (void)processMessages:(NSMutableDictionary*)messageDictionary {
  [messages addObject:@"wefwe"];
}

- (void)dealloc {
  [messages release];
  [super dealloc];
}

@end
