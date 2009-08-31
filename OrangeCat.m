
#import "OrangeCat.h"
#import "LocalStorage.h"
#import "OAuthGateway.h"

@implementation OrangeCat

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
  window.title = @"Orange Cat";
  [[NSFileManager defaultManager] createDirectoryAtPath:[LocalStorage localPath] attributes:nil];
  
  if ([LocalStorage getFile:@"request_token"]) {
  } else if () {
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
}

@end
