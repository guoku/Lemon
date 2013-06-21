//
//  NSString+GKHelper.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GKHelper)

- (NSString *)MD5Hash;
- (NSString *)toMD5String;
- (NSString *)encodeBase64String;
- (NSString *)decodeBase64String;
+ (BOOL)isValidEmail:(NSString *)email;
+ (NSString *)SignWithParamters:(NSDictionary *)paramters;
+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion newVersion : (NSString *)newVersion;
@end
