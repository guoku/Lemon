//
//  GKEntity.h
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKDBCore.h"
#import "GKEntityLike.h"

@interface GKEntity : NSObject

@property (readonly) NSUInteger entity_id;
@property (readwrite) NSUInteger pid;
@property (readonly) NSString * brand;
@property (nonatomic,strong) NSMutableArray * remark_list;
@property (readonly) float avg_score;
@property (nonatomic,strong) NSMutableArray * purchase_list;
@property (nonatomic,strong) NSMutableArray * pid_list;
@property (readonly) NSUInteger cid;
@property (readonly) NSString * title;
@property (unsafe_unretained, readonly) NSURL * imageURL;
@property (readwrite) NSUInteger used_count;
@property (readwrite) NSUInteger liked_count;
@property (readonly) float price;
@property (readonly) NSDate * created_time;
@property (readwrite) NSUInteger weight;
@property (readwrite) NSUInteger my_score;
@property (nonatomic, strong) GKEntityLike * entitylike;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (GKEntity *)save;
- (id)initFromSQLiteWithRsSet:(FMResultSet *)rs;
+ (NSArray *)getNeedResquestEntity;
+ (NSArray *)getEntityWithPid:(NSUInteger)pid;
@end
