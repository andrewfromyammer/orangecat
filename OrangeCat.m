
#import "OrangeCat.h"
#import "LocalStorage.h"
#import "OAuthGateway.h"
#import "FeedMessageList.h"
#import "APIGateway.h"

@implementation OrangeCat

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
  //NSImage* image = 
  NSImageView* imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 52, 48, 48)];
  //NSImageCell* cell = [[NSImageCell alloc] initImageCell:[NSImage imageNamed:@"no_photo_small.png"]];
  [imageView setImage:[NSImage imageNamed:@"no_photo_small.png"]];
  NSTextField* from = [[NSTextField alloc] initWithFrame:NSMakeRect(55, 52, 300, 30)];
  [from setEditable:NO];
  [from setBordered:NO];
  [from setStringValue:@"wefwefwefwefwe"];
  [view1 addSubview:from];


  [view1 addSubview:imageView];
  
  [collection setMaxNumberOfColumns:1];
  [collection setMinItemSize:NSMakeSize(350, 100)];
  [collectionItem setView:view1];
  
  [window setContentView:scroll];
  [NSThread detachNewThreadSelector:@selector(loadFeeds) toTarget:self withObject:nil];
}

- (void)test {
  [arrayController insertObject: [NSDictionary dictionaryWithObjectsAndKeys:@"Jon", @"Name", @"Male", @"Gender",nil] atArrangedObjectIndex:0];  
  [arrayController insertObject: [NSDictionary dictionaryWithObjectsAndKeys:@"Jon", @"Name", @"Male", @"Gender",nil] atArrangedObjectIndex:0];  
}

- (void)loadFeeds {
  NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
//  NSCollectionView
  
  NSMutableDictionary* messages = [APIGateway messages:[OrangeCat getMyFeed] newerThan:nil style:nil];
  FeedMessageList* data = [[FeedMessageList alloc] init];
  
  [data processMessages:messages];
  
  
  NSView* view1 = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 320, 100)];
  NSButton* button1 = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 40)];
  [button1 setTitle:@"2222222222"];
  [view1 addSubview:button1];
  
  [self performSelectorOnMainThread:@selector(test)
                         withObject:nil
                      waitUntilDone:YES];
  
  //[table setDataSource:data];
  //[table reloadData];
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
