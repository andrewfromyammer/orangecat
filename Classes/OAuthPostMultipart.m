#import "OAuthPostMultipart.h"
#import "OAuthCustom.h"
#import "OAuthGateway.h"
#import "LocalStorage.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"

@implementation OAuthPostMultipart

+ (BOOL)makeHTTPConnection:(NSMutableDictionary *)params path:(NSString *)path data:(NSData *)data {  
  
  NSURL *url = [OAuthGateway fixRelativeURL:path];
  
  OAConsumer *consumer = [[OAConsumer alloc] initWithKey:OAUTH_KEY
                                                  secret:OAUTH_SECRET];
  
  OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:[LocalStorage getFile:@"access_token"]];
  
  OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                 consumer:consumer
                                                                    token:accessToken
                                                                    realm:nil   
                                                        signatureProvider:nil];
  
  [request setHTTPMethod:@"POST"];
  
  NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
  
	NSMutableData *body = [NSMutableData data];
  // TODO: use params vs "test msg"
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  NSEnumerator *enumerator = [params keyEnumerator];
  NSString *key;
  while ((key = (NSString *)[enumerator nextObject])) {
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[params objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  }
	
	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"attachment1\"; filename=\"iphonefile.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:data]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];  
  
  [request prepare];
  
	[request setHTTPBody:body];
  [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
  [request setValue:contentType forHTTPHeaderField:@"Content-Type"]; 
  
  return [OAuthGateway handleConnection:request style:nil] != nil;
}

@end
