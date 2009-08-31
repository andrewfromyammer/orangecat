
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
    authCode = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(140, 560, 80, 30))];
    [window.contentView addSubview:authCode];    

    NSButton* authButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(100, 500, 200, 50))];
    [authButton setBezelStyle:NSTexturedRoundedBezelStyle];
    [authButton setTitle:@"Submit Code"];
    [authButton setAction:@selector(doCode)];
    [window.contentView addSubview:authButton];
  } else if ([LocalStorage getFile:@"access_token"]) {
    [self setupFeeds];
  } else {
    NSButton* authButton = [[NSButton alloc] initWithFrame:NSRectFromCGRect(CGRectMake(100, 500, 200, 50))];
    [authButton setBezelStyle:NSTexturedRoundedBezelStyle];
    [authButton setTitle:@"Begin Authorization"];
    [authButton setAction:@selector(doAuth)];
    [window.contentView addSubview:authButton];
  }
}

// 3238
- (void)doAuth {
  [OAuthGateway getRequestToken:NO];
  exit(0);
}

- (void)doCode {
  [OAuthGateway getAccessToken:[authCode stringValue]];
  [self setupFeeds];
}

- (void)setupFeeds {
  [table setDataSource:[[FeedMessageList alloc] init]];
  [window setContentView:scroll];  
  [NSThread detachNewThreadSelector:@selector(loadFeeds) toTarget:self withObject:nil];
}

- (void)loadFeeds {
  NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
  
  NSMutableDictionary* messages = [APIGateway messages:[OrangeCat getMyFeed] newerThan:nil style:nil];
  FeedMessageList* data = [[FeedMessageList alloc] init];
  
  [data processMessages:messages];
  
  [table setDataSource:data];
  [table reloadData];
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
