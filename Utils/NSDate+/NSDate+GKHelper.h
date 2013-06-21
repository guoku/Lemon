//
//  NSDate+GKHelper.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GKHelper)

+ (NSString *)now;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date WithFormatter:(NSString *)format;
- (NSDate *) dateForSqlite;
+ (NSDate*) dateFromSQLString:(NSString*)dateStr;
- (NSString *)stringByMessageFormatLongFormat:(BOOL)longFormat;
- (NSString *)stringByConvertToChineseStyle;
@end
