//
//  EGG.h
//  EGG
//
//  Created by Jianhuan Geng on 4/6/13.
//  Copyright (c) 2013 EGG, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EGG : NSObject

@property (nonatomic, readonly, copy) NSString *appToken;

/**
 完成对 EGG 的配置，只要在你应用的 `-application:didFinishLaunchingWithOptions:`
 方法中调用 `+launchWithAppToken:` 方法即可。
 
 `appToken` 可以在 EGG 上你创建的 App 页面中获得。
 */
+ (EGG *)launchWithAppToken:(NSString *)appToken;

/**
 访问 EGG 单例。与 `+launchWithAppToken:` 返回同一对象。
 */
+ (EGG *)sharedInstance;

/**
 调用后即可制造一次崩溃，方便测试。
 */
- (void)crash;

@end
