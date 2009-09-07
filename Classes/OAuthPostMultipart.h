
#import <Foundation/Foundation.h>


@interface OAuthPostMultipart : NSObject {

}

+ (BOOL)makeHTTPConnection:(NSMutableDictionary *)params path:(NSString *)path data:(NSData *)data;

@end
