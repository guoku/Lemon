//
//  GKDBCore.h
//  Grape
//
//  Created by 谢家欣 on 13-4-10.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface GKDBCore : NSObject

@property (readonly) FMDatabase * db;
@property (readonly) NSString * dbpath;

- (BOOL)beginTransaction;
- (BOOL)commit;
- (BOOL)createTableWithSQL:(NSString *)sql;
//- (BOOL)insertDataWithSQL:(NSString *)sql Args:(NSArray *)array;
- (BOOL)insertDataWithSQL:(NSString *)sql ArgsDict:(NSDictionary *)argsDict;
- (BOOL)removeDataWithSQL:(NSString *)sql ArgsDict:(NSDictionary *)argsDict;
- (FMResultSet *)queryDataWithSQL:(NSString *)sql;
- (FMResultSet *)queryDataWithSQL:(NSString *)sql ArgsDict:(NSDictionary *)argsDict;
+ (GKDBCore *)sharedDB;
@end
