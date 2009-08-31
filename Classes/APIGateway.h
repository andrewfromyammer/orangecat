
#import <Foundation/Foundation.h>


@interface APIGateway : NSObject {

}


+ (NSMutableDictionary *)messages:(NSMutableDictionary *)feed olderThan:(NSNumber *)olderThan style:(NSString *)style;
+ (NSMutableDictionary *)messages:(NSMutableDictionary *)feed newerThan:(NSNumber *)newerThan style:(NSString *)style;
+ (NSMutableDictionary *)messages:(NSMutableDictionary *)feed olderThan:(NSNumber *)olderThan newerThan:(NSNumber *)newerThan style:(NSString *)style;


@end
