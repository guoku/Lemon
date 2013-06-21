//
//  GKEntity.h
//  Grape
//
//  Created by 谢 家欣 on 13-3-27.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKDBCore.h"

#import "GKNote.h"
#import "GKEntityLike.h"

@interface GKEntity : NSObject

@property (readonly) NSUInteger entity_id;
@property (readonly) NSString * taobao_id;
@property (readonly) NSString * entity_hash;
@property (readonly) NSString * title;
@property (readonly) NSString * urlString;
@property (unsafe_unretained, readonly) NSURL * imageURL;
@property (readonly) NSString * brand;
@property (readonly) NSString * stuff_status;
@property (readonly) float price;
@property (readonly) NSUInteger category_id;
@property (readwrite) NSUInteger liked_count;
@property (readonly) NSDate * created_time;
@property (readonly) NSUInteger popularity;
@property (nonatomic, strong) GKEntityLike * entitylike;

@property (nonatomic, strong) NSMutableArray * notes_list;

- (id)initWithAttributes:(NSDictionary *)attributes;
- (id)initFromSQLiteWithRsSet:(FMResultSet *)rs;
//- (id)initAndSaveWithAttributes:(NSDictionary *)attributes;
- (GKEntity *)save;
@end
