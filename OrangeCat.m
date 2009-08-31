
#import "OrangeCat.h"
#import "LocalStorage.h"
#import "OAuthGateway.h"

@implementation OrangeCat

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
  window.title = @"Orange Cat";
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
}

@end
