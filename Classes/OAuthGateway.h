#import "OAMutableURLRequest.h"

@interface OAuthGateway : NSObject {

}

+ (NSString *)baseURL;
+ (void)getRequestToken:(BOOL)createNewAccount;
+ (BOOL)getAccessToken:(NSString *)code;
+ (NSURL *)fixRelativeURL:(NSString *)path;
+ (NSString *)handleConnection:(OAMutableURLRequest *)request style:(NSString *)style;
+ (NSString *)httpGet:(NSString *)path style:(NSString *)style;

@end
