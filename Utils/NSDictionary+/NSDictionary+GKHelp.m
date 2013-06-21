//
//  NSDictionary+GKHelp.m
//  Grape
//
//  Created by 谢家欣 on 13-3-31.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "NSDictionary+GKHelp.h"
#import "NSString+GKHelper.h"
#import "GKAPICode.h"
@implementation NSDictionary (GKHelp)

- (NSDictionary *)Paramters
{
    NSMutableDictionary * _parameters = [NSMutableDictionary dictionaryWithDictionary:self];
    [_parameters setValue:kGuokuApiKey forKey:@"api_key"];
    NSString * _sessionID = [kUserDefault stringForKey:kSession];
    if (_sessionID)
        [_parameters setValue:_sessionID forKey:@"session"];
    [_parameters setValue:[NSString SignWithParamters:_parameters] forKey:@"sign"];
//    GKLog(@"%@", _parameters)
    return _parameters;
}

- (NSDictionary *)listResponse
{
    NSUInteger res_code = [[self valueForKeyPath:@"res_code"] unsignedIntegerValue];
//    NSArray * listFormResponse = [NSArray array];
    NSDictionary *  ResponseData = [NSDictionary dictionary];
    switch (res_code) {
        case SUCCESS:
        {
            ResponseData = [self valueForKeyPath:@"results"];
        }
            break;
            
        default:
            break;
    }
    
    return ResponseData;
}

- (NSString*) stringForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSString class]]) {
		return nil;
	}
	return s;
}

- (NSNumber*) numberForKey:(id)key {
	id s = [self objectForKey:key];
	if (s == [NSNull null] || ![s isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	return s;
}

@end
