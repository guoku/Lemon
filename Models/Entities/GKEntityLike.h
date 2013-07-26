//
//  GKEntityLike.h
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKEntityLike : NSObject

@property (readonly) NSUInteger entity_id;
@property (readonly) BOOL status;

- (id)initWithAttributes:(NSDictionary *)attributes;
//- (BOOL)saveToSQLite;
//- (void)saveToSQLite;
//- (BOOL)deleteWithEntityID:(NSUInteger)entity_id UserID:(NSUInteger)user_id;

//+ (BOOL)createTableAndIndex;
//+ (void)DeleteAllData;
+ (GKEntityLike *)getEntityLikeStatusFromSQLiteWithEntityID:(NSUInteger)entity_id;
+ (void)changeLikeActionWithEntityID:(NSUInteger)entity_id
                            Selected:(BOOL)selected
                               Block:(void (^)(NSDictionary *dict, NSError * error))block;


@end
