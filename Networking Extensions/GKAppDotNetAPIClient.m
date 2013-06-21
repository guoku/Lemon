//
//  GKAppDotNetAPIClient.m
//  Grape
//
//  Created by 谢家欣 on 13-3-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "GKAppDotNetAPIClient.h"

#import "AFJSONRequestOperation.h"


@implementation GKAppDotNetAPIClient
+ (GKAppDotNetAPIClient *)sharedClient {
    static GKAppDotNetAPIClient * _shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareClient = [[GKAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kGKAppBaseURL]];
    });
    return _shareClient;
}


- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(self)
    {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}
@end
