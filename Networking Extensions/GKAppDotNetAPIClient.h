//
//  GKAppDotNetAPIClient.h
//  Grape
//
//  Created by 谢家欣 on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface GKAppDotNetAPIClient : AFHTTPClient
+ (GKAppDotNetAPIClient *)sharedClient;
@end
