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
  return [messages count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  
  NSDictionary* message = [messages objectAtIndex:rowIndex];
  //return [message objectForKey:@"fromLine"];
  
  if ([aTableColumn.identifier isEqualToString:@"image"])
    return [NSImage imageNamed:@"no_photo_small.png"];
  else
    return [NSString stringWithFormat:@"%@\n%@", [message objectForKey:@"fromLine"], 
                                                 [[message objectForKey:@"body"] objectForKey:@"plain"]];
}

+ (NSString*)safeName:(NSMutableDictionary*)dict {
  NSString* name = @"";
  if ([[dict objectForKey:@"full_name"] isKindOfClass:[NSString class]])
    name = [dict objectForKey:@"full_name"];  
  return name;
}

- (NSArray *)processMessages:(NSMutableDictionary*)dict {
    
  NSMutableArray *references = [dict objectForKey:@"references"];
  
  NSMutableDictionary *referencesByType = [NSMutableDictionary dictionary];
  
  int i=0;
  for (i=0; i < [references count]; i++) {
    NSMutableDictionary *reference = [references objectAtIndex:i];
    NSString *type = [reference objectForKey:@"type"];
    NSString *ref_id = [reference objectForKey:@"id"];
    
    if (type) {
      NSMutableDictionary *referencesById = [referencesByType objectForKey:type];
      if (!referencesById) {
        referencesById = [NSMutableDictionary dictionary];
        [referencesByType setObject:referencesById forKey:type];
      }
      [referencesById setObject:reference forKey:ref_id];
    }
  }
  
  NSMutableArray *tempMessages = [dict objectForKey:@"messages"];
  
  for (i=0; i < [tempMessages count]; i++) {
    @try {
      NSMutableDictionary *message = [tempMessages objectAtIndex:i];
      NSMutableDictionary *referencesById = [referencesByType objectForKey:[message objectForKey:@"sender_type"]];
      NSMutableDictionary *actor = [referencesById objectForKey:[message objectForKey:@"sender_id"]];
      
      [message setObject:[actor objectForKey:@"mugshot_url"] forKey:@"actor_mugshot_url"];
      [message setObject:[actor objectForKey:@"id"] forKey:@"actor_id"];
      [message setObject:[actor objectForKey:@"type"] forKey:@"actor_type"];
      
      [message setObject:[FeedMessageList safeName:actor] forKey:@"sender"];
      
      referencesById = [referencesByType objectForKey:@"message"];
      NSMutableDictionary *messageRef = [referencesById objectForKey:[message objectForKey:@"replied_to_id"]];
      
      if (messageRef) {
        referencesById = [referencesByType objectForKey:[messageRef objectForKey:@"sender_type"]];
        NSMutableDictionary *actor = [referencesById objectForKey:[messageRef objectForKey:@"sender_id"]];
        
        [message setObject:[FeedMessageList safeName:actor] forKey:@"reply_name"];
      }
      
      referencesById = [referencesByType objectForKey:@"thread"];
      NSMutableDictionary *threadRef = [referencesById objectForKey:[message objectForKey:@"thread_id"]];
      if (threadRef) {  
        [message setObject:[threadRef objectForKey:@"url"] forKey:@"thread_url"];
        NSMutableDictionary *threadStats = [threadRef objectForKey:@"stats"];
        [message setObject:[threadStats objectForKey:@"updates"] forKey:@"thread_updates"];
        [message setObject:[threadStats objectForKey:@"first_reply_id"] forKey:@"thread_first_reply_id"];
        [message setObject:[threadStats objectForKey:@"first_reply_at"] forKey:@"thread_first_reply_at"];
        [message setObject:[threadStats objectForKey:@"latest_reply_id"] forKey:@"thread_latest_reply_id"];
        [message setObject:[threadStats objectForKey:@"latest_reply_at"] forKey:@"thread_latest_reply_at"];
      }
      
      referencesById = [referencesByType objectForKey:@"group"];
      NSMutableDictionary *groupRef = [referencesById objectForKey:[message objectForKey:@"group_id"]];
      
      if (groupRef) {
        [message setObject:[groupRef objectForKey:@"name"] forKey:@"group_name"];
        [message setObject:[groupRef objectForKey:@"full_name"] forKey:@"group_full_name"];
        [message setObject:[groupRef objectForKey:@"privacy"] forKey:@"group_privacy"];
        if ([[groupRef objectForKey:@"privacy"] isEqualToString:@"private"]) {
          [message setObject:[NSString stringWithFormat:@"%@", [groupRef objectForKey:@"name"]] forKey:@"group_name"];
          [message setObject:@"true" forKey:@"lock"];
        }
      }
      
      referencesById = [referencesByType objectForKey:@"user"];
      NSMutableDictionary *directRef = [referencesById objectForKey:[message objectForKey:@"direct_to_id"]];
      
      NSString *fromLine  = [message objectForKey:@"sender"];
      NSString *replyName = [message objectForKey:@"reply_name"];
      
      if (directRef) {
        
        fromLine = [NSString stringWithFormat:@"%@ to: %@", [message objectForKey:@"sender"], [FeedMessageList safeName:directRef]];
        [message setObject:@"true" forKey:@"lock"];
        [message setObject:@"true" forKey:@"lockColor"];
      }
      
      if (replyName && directRef == nil)
        fromLine = [NSString stringWithFormat:@"%@ re: %@", [message objectForKey:@"sender"], replyName];
      if (replyName && directRef != nil)
        fromLine = [NSString stringWithFormat:@"%@ re: %@", [message objectForKey:@"sender"], replyName];
      
      
      [message setObject:fromLine forKey:@"fromLine"];
    } @catch (NSException *theErr) {}
  }
  
  [messages addObjectsFromArray:tempMessages];
  return tempMessages;
}

- (void)dealloc {
  [messages release];
  [super dealloc];
}

@end
