//
//  IMTCPserver.h
//  im
//
//  Created by tongho on 16/7/18.
//  Copyright © 2016年 tongho. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ClientSuccess)();
typedef void(^ClientFailure)(NSError* error);

@interface IMTCPServer : NSObject

- (void)loginTcpServerIP:(NSString*)ip
                    port:(NSInteger)point
                 Success:(void(^)())success
                 failure:(void(^)())failure;
@end
