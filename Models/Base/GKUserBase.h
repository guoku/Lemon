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
@property (readonly) NSString * username;
@property (readonly) NSString * nickname;
@property (readonly) NSString * gender;
@property (readonly) NSString * location;
@property (readonly) NSString * email;
@property (readonly) NSString * website;
@property (readonly) NSString * bio;
@property (unsafe_unretained, readonly) NSURL * avatarImageURL;

- (id)initFromSQLiteWithRS:(FMResultSet *)rs;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
