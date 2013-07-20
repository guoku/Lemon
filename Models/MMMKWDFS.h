//
//  MMMKWDFS.h
//  MMM
//
//  Created by huiter on 13-7-20.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMKWDFS : GKEntity

@property (strong,nonatomic) NSMutableArray * likes_list;
@property (strong,nonatomic) NSMutableArray * notes_list;
@property (strong,nonatomic) NSMutableArray * likes_user_list;

- (id)initWithAttributes:(NSDictionary *)attributes;
+ (void)globalKWDFSWithPid:(NSUInteger)pid Cid:(NSUInteger)cid Page:(NSUInteger)page Date:(NSDate *)date
                     Block:(void (^)(NSArray *array, NSError * error))block;
@end
