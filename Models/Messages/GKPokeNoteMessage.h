//
//  GKPokeNoteMessage.h
//  MMM
//
//  Created by huiter on 13-7-18.
//  Copyright (c) 2013年 guoku. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKPokeNoteMessage : NSObject
@property (readonly) GKUserBase * user;
@property (readonly) GKEntityBase * entity;
@property (readonly) GKNote * note;

- (id)initWithAttributes:(NSDictionary *)attributes;
@end
