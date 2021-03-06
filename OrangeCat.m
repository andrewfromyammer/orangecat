
#import "OrangeCat.h"
#import "LocalStorage.h"
#import "OAuthGateway.h"
#import "FeedMessageList.h"
#import "APIGateway.h"

@implementation OrangeCat

@synthesize data, last;

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
  window.title = @"OrangeCat";
  [[NSFileManager defaultManager] createDirectoryAtPath:[LocalStorage localPath] attributes:nil];
  
  if ([LocalStorage getFile:@"request_token"]) {
    [self setupCode];
  } else if ([LocalStorage getFile:@"access_token"]) {
    [self setupFeeds];
  } else {
    NSButton* authButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(100, 500, 200, 50))];
    [authButton setBezelStyle:NSTexturedRoundedBezelStyle];
    [authButton setTitle:@"Begin Authorization"];
    [authButton setAction:@selector(doAuth)];
    NSView* view = [[NSView alloc] initWithFrame:[window frame]];
    [view addSubview:authButton];
    [window setContentView:view];
  }
}

// 3238
- (void)doAuth {
  [OAuthGateway getRequestToken:NO];
  [self setupCode];
}

- (void)doCode {
  [OAuthGateway getAccessToken:[authCode stringValue]];
  [self setupFeeds];
}

- (void)setupCode {
  authCode = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(140, 560, 80, 30))];
  
  NSButton* authButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(100, 500, 200, 50))];
  [authButton setBezelStyle:NSTexturedRoundedBezelStyle];
  [authButton setTitle:@"Submit Code"];
  [authButton setAction:@selector(doCode)];

  NSView* view = [[NSView alloc] initWithFrame:[window frame]];
  [view addSubview:authCode];
  [view addSubview:authButton];
  [window setContentView:view];
}

- (void)setupFeeds {
  //[table setDataSource:[[FeedMessageList alloc] init]];
  
  NSView* view1 = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 500, 100)];
  NSImageView* imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 52, 48, 48)];
  [imageView setImage:[NSImage imageNamed:@"no_photo_small.png"]];
  NSTextField* from = [[NSTextField alloc] initWithFrame:NSMakeRect(55, 70, 300, 30)];
  [from setEditable:NO];
  [from setBordered:NO];
  [from setFont:[NSFont boldSystemFontOfSize:12]];
  [view1 addSubview:from];
  [view1 addSubview:imageView];

  NSTextField* preview = [[NSTextField alloc] initWithFrame:NSMakeRect(55, 30, 300, 50)];
  [preview setEditable:NO];
  [preview setBordered:NO];
  [view1 addSubview:preview];

  NSTextField* time = [[NSTextField alloc] initWithFrame:NSMakeRect(55, 10, 300, 20)];
  [time setEditable:NO];
  [time setBordered:NO];
  [time setTextColor:[NSColor lightGrayColor]];
  [view1 addSubview:time];
  
  
  [collection setMaxNumberOfColumns:1];
  [collection setMinItemSize:NSMakeSize(360, 100)];
  [collectionItem setView:view1];

  NSView* view2 = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 400, 680)];
  NSTextView* input = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 580+40, 400, 60)];
  [input setRichText:NO];
  
  NSButton* updateButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(150, 580, 100, 40))];
  [updateButton setBezelStyle:NSTexturedRoundedBezelStyle];
  [updateButton setTitle:@"Update"];
  [updateButton setAction:@selector(doUpdate)];
  
  
  scroll.frame = NSMakeRect(0, -1, 400, 580);
  
  [view2 addSubview:input];
  [view2 addSubview:updateButton];
  [view2 addSubview:scroll];
  
  [window setContentView:view2];
  [NSThread detachNewThreadSelector:@selector(loadFeeds) toTarget:self withObject:nil];
}

- (void)doUpdate {
  if ([APIGateway createMessage:@"test" repliedToId:nil
                        groupId:nil
                      imageData:nil]) {
  }    
}

- (void)test {
  for (int i=[data.messages count]-1; i>=0; i--) {
    [arrayController insertObject: [data.messages objectAtIndex:i] atArrangedObjectIndex:0];
  }
}

- (void)test2:(NSArray*)array {
  for (int i=[array count]-1; i>=0; i--) {
    [arrayController insertObject: [array objectAtIndex:i] atArrangedObjectIndex:0];
  }
}

- (void)loadFeeds {
  NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
//  NSCollectionView
  
  NSMutableDictionary* messages = [APIGateway messages:[OrangeCat getMyFeed] newerThan:nil style:nil];
  self.data = [[FeedMessageList alloc] init];
  
  [data processMessages:messages];

  NSMutableDictionary* message = [data.messages objectAtIndex:0];
  self.last = [message objectForKey:@"id"];

  for (int i=0; i<[data.messages count]; i++) {
    message = [data.messages objectAtIndex:i];
    NSError* error;
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[message objectForKey:@"actor_mugshot_url"]] 
                                         options:0 error:&error];
    [message setObject:imageData forKey:@"image_data"];

  }
  
  [self performSelectorOnMainThread:@selector(test)
                         withObject:nil
                      waitUntilDone:YES];
  
  [NSThread detachNewThreadSelector:@selector(poll) toTarget:self withObject:nil];
  [autoreleasepool release];
}

- (void)poll {
  NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
  sleep(30);
  
  NSMutableDictionary* messages = [APIGateway messages:[OrangeCat getMyFeed] newerThan:self.last style:nil];

  NSArray* newOnes = [data processMessages:messages];
  
  for (int i=0; i<[newOnes count]; i++) {
    NSMutableDictionary* message = [newOnes objectAtIndex:i];
    
    if (i == 0)
      self.last = [message objectForKey:@"id"];
    
    NSError* error;
    NSData* imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[message objectForKey:@"actor_mugshot_url"]] 
                                              options:0 error:&error];
    [message setObject:imageData forKey:@"image_data"];
  }
  
  [self performSelectorOnMainThread:@selector(test2:)
                         withObject:newOnes
                      waitUntilDone:YES];
  
  [NSThread detachNewThreadSelector:@selector(poll) toTarget:self withObject:nil];  
  [autoreleasepool release];
}

+ (NSMutableDictionary *)getMyFeed {
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  [dic setObject:@"My Feed" forKey:@"name"];
  [dic setObject:@"following" forKey:@"type"];
  [dic setObject:@"/api/v1/messages/following" forKey:@"url"];
  [dic setObject:@"(null)" forKey:@"group_id"];
  
  return dic;
}

- (IBAction)doLogout:(id)sender {
  [LocalStorage removeFile:@"access_token"];
  exit(0);
}

@end
