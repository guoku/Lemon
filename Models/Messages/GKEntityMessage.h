//
//  GKEntityMessage.h
//  Grape
//
//  Created by 谢 家欣 on 13-4-22.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GKEntity;
@interface GKEntityMessage : NSObject

@property (nonatomic, strong) NSArray * note_id_list;
@property (nonatomic, strong) NSArray * liker_id_list;
@property (readonly) GKEntity * entity;
@property (readonly) BOOL added_to_selection;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
