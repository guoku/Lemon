//
//  GKFileManager.m
//  GK_ICM
//
//  Created by 梁 玮殷 on 4/9/12.
//  Copyright (c) 2012 果库. All rights reserved.
//

#import "GKFileManager.h"

@implementation GKFileManager

+ (NSString *)getFullFileNameWithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [docDir stringByAppendingPathComponent:name];
    
    return fileName;
}

+ (BOOL)fileExistsWithName:(NSString *)name
{
    BOOL res = [[NSFileManager defaultManager] fileExistsAtPath:[GKFileManager getFullFileNameWithName:name]];
    
    return res;
}

+ (void)removeFileWithName:(NSString *)name
{
    [[NSFileManager defaultManager] removeItemAtPath:[GKFileManager getFullFileNameWithName:name] error:nil];
}

@end
