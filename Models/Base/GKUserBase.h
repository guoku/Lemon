//
//  GKUserBase.h
//  Grape
//
//  Created by 谢家欣 on 13-4-28.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GKUserBase : NSObject
@property (readonly) NSUInteger user_id;
@property (readonly) NSString * nickname;
@property (readonly) NSString * gender;
@property (unsafe_unretained, readonly) NSURL * avatarImageURL;
@property (readonly) NSString * location;
@property (readonly) NSString * city;
@property (nonatomic, strong) GKUserRelation * relation;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)getUserBaseByArray:(NSArray *)array Block:(void (^)(NSArray * entitylist, NSError *error))block;
@end
