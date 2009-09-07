#import "APIGateway.h"
#import "OAuthGateway.h"
#import "NSString+SBJSON.h"
#import "LocalStorage.h"
#import "NSString+SBJSON.h"
#import "OAuthPostURLEncoded.h"
#import "OAuthPostMultipart.h"

@implementation APIGateway


+ (NSMutableDictionary *)messages:(NSMutableDictionary *)feed olderThan:(NSNumber *)olderThan style:(NSString *)style {
  return [APIGateway messages:feed olderThan:olderThan newerThan:nil style:style];
}

+ (NSMutableDictionary *)messages:(NSMutableDictionary *)feed newerThan:(NSNumber *)newerThan style:(NSString *)style {
  return [APIGateway messages:feed olderThan:nil newerThan:newerThan style:style];
}

+ (NSMutableDictionary *)messages:(NSMutableDictionary *)feed olderThan:(NSNumber *)olderThan 
                                                          newerThan:(NSNumber *)newerThan
                                                          style:(NSString *)style {
  
  NSString *url = [feed objectForKey:@"url"];
  NSMutableString *params = [NSMutableString stringWithCapacity:10];
  if (olderThan)
    [params appendFormat:@"?older_than=%@", olderThan];
  if (newerThan)
    [params appendFormat:@"?newer_than=%@", newerThan];
  
  BOOL threadedOkay = false;
//  if ([LocalStorage threading] && [feed objectForKey:@"isThread"] == nil)
//    threadedOkay = true;

  if (threadedOkay && (newerThan != nil || olderThan != nil))
    [params appendString:@"&threaded=true"];
  else if (threadedOkay)
    [params appendString:@"?threaded=true"];
  
  
  NSString *json = [OAuthGateway httpGet:[NSString stringWithFormat:@"%@.json%@", url, params] style:(NSString *)style];
  
  if (json)
    return (NSMutableDictionary *)[json JSONValue];
  
  return nil;
}

+ (BOOL)createMessage:(NSString *)body repliedToId:(NSNumber *)repliedToId 
              groupId:(NSNumber *)groupId
            imageData:(NSData *)imageData {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  [params setObject:body forKey:@"body"];
  if (repliedToId)
    [params setObject:[repliedToId description] forKey:@"replied_to_id"];
  if (groupId)
    [params setObject:[groupId description] forKey:@"group_id"];
  
  if (imageData)
    return [OAuthPostMultipart makeHTTPConnection:params path:@"/api/v1/messages" data:imageData];
  else
    return [OAuthPostURLEncoded makeHTTPConnection:params path:@"/api/v1/messages" method:@"POST"];
}


@end
