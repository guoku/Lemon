//
//  NSDictionary+GKHelp.h
//  Grape
//
//  Created by 谢家欣 on 13-3-31.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GKHelp)
- (NSString*) stringForKey:(id)key;
- (NSNumber*) numberForKey:(id)key;
- (NSDictionary *)Paramters;
- (NSDictionary *)listResponse;
@end
