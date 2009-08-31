
@interface OAuthGateway : NSObject {

}

+ (NSString *)baseURL;
+ (void)getRequestToken:(BOOL)createNewAccount;
+ (BOOL)getAccessToken:(NSString *)code;

@end
