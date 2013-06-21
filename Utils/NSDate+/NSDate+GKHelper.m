//
//  NSDate+GKHelper.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//
static NSDateFormatter *ShortDateFormatter;
#import "NSDate+GKHelper.h"

@implementation NSDate (GKHelper)
- (NSString *)stringByMessageFormatLongFormat:(BOOL)longFormat {
    NSTimeInterval minutes = - [self timeIntervalSinceNow] / 60;
    
    if (minutes < 1) {
        return @"刚刚";
    } else if (minutes < 60) {
        return [NSString stringWithFormat:@"%.0f分钟前", minutes];
    } else if (minutes < 60 * 24) {
        return [NSString stringWithFormat:@"%.0f小时前", minutes / 60];
    } else if (minutes < 60 * 24 * 2) {
        return [NSString stringWithFormat:@"%.0f天前", minutes / 60 / 24];
    } else {
        if (longFormat) {
            return [self stringByConvertToChineseStyle];
        } else {
            if (ShortDateFormatter == nil) {
                ShortDateFormatter = [[NSDateFormatter alloc] init];
                [ShortDateFormatter setDateFormat:@"M月d日"];
                [ShortDateFormatter setLocale:[NSLocale currentLocale]];
            }
            return [ShortDateFormatter stringFromDate:self];
        }
    }
}

- (NSString *)stringByConvertToChineseStyle
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y年M月d日"];
    [formatter setLocale:[NSLocale currentLocale]];
    
    NSString *output = [formatter stringFromDate:self];
    return output;
}
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * destDate = [dateFormatter dateFromString:dateString];
    return  destDate;
}

+ (NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:format];
    NSDate * destDate = [dateFormatter dateFromString:dateString];
    return  destDate;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
+ (NSString *)stringFromDate:(NSDate *)date WithFormatter:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    NSString * destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
+ (NSString *)now
{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate * now = [date dateByAddingTimeInterval:interval];
    NSString * dateString  = [now description];
    NSArray * dateArr = [dateString componentsSeparatedByString:@" "];
    return [NSString stringWithFormat:@"%@ %@", [dateArr objectAtIndex:0], [dateArr objectAtIndex:1]];
}

#pragma mark -
#pragma mark SQLite formatting


- (NSDate *) dateForSqlite {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *ret = [formatter stringFromDate:self];
    
    NSDate *date = [formatter dateFromString:ret];
    
    return date;
}

+ (NSDate*) dateFromSQLString:(NSString*)dateStr {
    
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *date = [dateForm dateFromString:dateStr];
    return date;
}
@end
