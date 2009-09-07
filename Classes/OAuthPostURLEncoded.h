

#import <Foundation/Foundation.h>


@interface OAuthPostURLEncoded : NSObject {

}

+ (BOOL)makeHTTPConnection:(NSMutableDictionary *)params path:(NSString *)path method:(NSString *)method;

@end
