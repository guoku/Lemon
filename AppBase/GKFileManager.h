//
//  GKFileManager.h
//  GK_ICM
//
//  Created by 梁 玮殷 on 4/9/12.
//  Copyright (c) 2012 妈妈清单. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKFileManager : NSObject

+ (NSString *)getFullFileNameWithName:(NSString *)name;
+ (BOOL)fileExistsWithName:(NSString *)name;
+ (void)removeFileWithName:(NSString *)name;

@end
