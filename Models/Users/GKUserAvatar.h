//
//  GKUserAvatar.h
//  Grape
//
//  Created by 谢家欣 on 13-3-23.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKUserAvatar : NSObject

@property (readonly) NSUInteger user_id;
@property (unsafe_unretained, readonly) NSURL * avatarOriginURL;
@property (unsafe_unretained, readonly) NSURL * avatarSmallURL;
@property (unsafe_unretained, readonly) NSURL * avatarLargeURL;

- (id)initFromSQLiteWithUserID:(NSUInteger)user_id;
- (id)initWithAttributes:(NSDictionary *)attributes;
- (BOOL)saveToSQLite;
- (BOOL)removeFromSQLiteWithUserID:(NSUInteger)user_id;
@end
