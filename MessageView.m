#import "NSDate-Ago.h"
#import "MessageView.h"

@implementation MessageView

/*
- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
  
  // Get a copy of the item prototype, set represented object
  NSCollectionViewItem *newItem = [[self itemPrototype] copy];
  [newItem setRepresentedObject:object];
  
  // Get the new item's view so you can mess with it
  NSView *itemView = [newItem view];
  
  //
  // add your controls to the view here, bind, etc
  //
  
  return newItem;
}
*/

- (void)setRepresentedObject:(id)object {
  NSDictionary* dict = (NSDictionary*)object;
  NSView* view = [self view];
  NSTextField* from = [view.subviews objectAtIndex:0];
  if ([dict objectForKey:@"fromLine"])
    [from setStringValue:[dict objectForKey:@"fromLine"]];
  NSImageView* image = [view.subviews objectAtIndex:1];
  image.image = [[NSImage alloc] initWithData:[dict objectForKey:@"image_data"]];
  NSTextField* preview = [view.subviews objectAtIndex:2];
  
  NSDictionary* body = [dict objectForKey:@"body"];
  NSString* previewText = [body objectForKey:@"plain"];
  if (previewText)
    [preview setStringValue:previewText];

  NSTextField* time = [view.subviews objectAtIndex:3];
  if ([dict objectForKey:@"created_at"]) {
    NSString* text = [dict objectForKey:@"created_at"];
    
    NSString *front = [text substringToIndex:10];
    NSString *end = [[text substringFromIndex:11] substringToIndex:8];
    NSDate* date = [NSDate dateWithString:[NSString stringWithFormat:@"%@ %@ -0000", front, end]];
    
    [time setStringValue:[date agoDate]];
  }

}

@end
