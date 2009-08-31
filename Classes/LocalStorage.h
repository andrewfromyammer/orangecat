//
//  LocalStorage.h
//  Yammer
//
//  Created by aa on 1/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorage : NSObject {

}

+ (NSString *)localPath;

+ (void)saveFile:(NSString *)name data:(NSString *)data;
+ (NSString *)getFile:(NSString *)name;
+ (void)removeFile:(NSString *)name;

@end
