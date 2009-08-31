
@interface OAuthGateway : NSObject {

}

+ (void)getRequestToken:(BOOL)createNewAccount;
+ (BOOL)getAccessToken:(NSString *)code;

@end
