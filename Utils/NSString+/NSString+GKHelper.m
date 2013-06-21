//
//  NSString+GKHelper.m
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import "NSString+GKHelper.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (GKHelper)

- (NSString *)MD5Hash {
    
	CC_MD5_CTX md5;
	CC_MD5_Init (&md5);
	CC_MD5_Update (&md5, [self UTF8String], [self length]);
    
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final (digest, &md5);
	NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
				   digest[0],  digest[1],
				   digest[2],  digest[3],
				   digest[4],  digest[5],
				   digest[6],  digest[7],
				   digest[8],  digest[9],
				   digest[10], digest[11],
				   digest[12], digest[13],
				   digest[14], digest[15]];
    
	return s;
}

- (NSString *)toMD5String
{
    //GKLog(@"toMD5---%@",self);
    const char *src = [self  UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, strlen(src), result);
    NSString * ret = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3],
                      result[4], result[5], result[6], result[7],
                      result[8], result[9], result[10], result[11],
                      result[12], result[13], result[14], result[15]];
    return ret;
}

- (NSString*)encodeBase64String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

- (NSString*)decodeBase64String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (BOOL)isValidEmail:(NSString *)email
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)SignWithParamters:(NSDictionary *)paramters
{
    NSMutableString * signString = [NSMutableString string];
    NSMutableArray * keys = [NSMutableArray arrayWithArray:[paramters allKeys]];
    [keys sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSMutableArray *paramtersArray = [NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < [keys count]; i++)
    {
        if (![[keys objectAtIndex:i] isEqualToString:@"avatar_data"]) {
            NSString * string = [NSString stringWithFormat:@"%@=%@", [keys objectAtIndex:i], [paramters valueForKey:[keys objectAtIndex:i]]];
            [paramtersArray addObject:string];
//            [signString appendString:string];
        }
    }
    for (int i = 0; i<[paramtersArray count]; i++) {
        [signString appendString:[paramtersArray objectAtIndex:i]];
    }
    
    [signString appendString:kGuokuApiSecret];
//    GKLog(@"%@", signString);
    NSString * sign = [[signString toMD5String] lowercaseString];
    
    return sign;
}
+(BOOL)CompareVersionFromOldVersion : (NSString *)oldVersion newVersion : (NSString *)newVersion
{
    NSArray*oldV = [oldVersion componentsSeparatedByString:@"."];
    NSArray*newV = [newVersion componentsSeparatedByString:@"."];

    for (NSInteger i = 0; i < oldV.count; i++) {
        if (i < newV.count) {
            NSInteger old = [(NSString *)[oldV objectAtIndex:i] integerValue];
            NSInteger new = [(NSString *)[newV objectAtIndex:i] integerValue];
            if (old < new) {
                return YES;
            }
            if(old == new)
            {
            }
            else{
                return NO;
            }
        }
        
    }
    if ([oldV count] < [newV count]) {
        return YES;
    }
    return NO;
}
@end
