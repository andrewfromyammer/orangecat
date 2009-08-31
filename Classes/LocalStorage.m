#import "LocalStorage.h"
#import "NSString+SBJSON.h"

@implementation LocalStorage

+ (NSString *)localPath {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
  return [NSString stringWithFormat:@"%@/OrangeCat/", basePath];
}

+ (NSString *)getFile:(NSString *)name {  
  NSString *documentsDirectory = [LocalStorage localPath];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  if (![fileManager fileExistsAtPath:[documentsDirectory stringByAppendingPathComponent:name]])
    return nil;
  
  return [[NSString alloc] initWithData:[fileManager contentsAtPath:
                                         [documentsDirectory stringByAppendingPathComponent:name]]
                               encoding:NSUTF8StringEncoding];
}

+ (void)saveFile:(NSString *)name data:(NSString *)data {
  NSString *documentsDirectory = [LocalStorage localPath];  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  [fileManager createFileAtPath:[documentsDirectory stringByAppendingPathComponent:name]
                       contents:[data dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

+ (void)removeFile:(NSString *)name {
  NSError *error;
  NSString *documentsDirectory = [LocalStorage localPath];  
  NSFileManager *fileManager = [NSFileManager defaultManager];  
  [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:name] error:&error];    
}


@end
