//
//  YXCommonUtil.h
//  Mobileyx
//
//  Created by 常见 on 2017/8/15.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YXCommonUtil : NSObject

+(BOOL)isNumber:(NSString *)number;

/**
 *  获取当前窗口rootViewController
 */
+(UIViewController *)rootViewController;

/**
 *  获取当前窗口最上层viewcontroller
 */
+(UIViewController *)topViewController;

//检测是不是空白字符串
+(BOOL)isBlankString:(NSString *)string;

// 在当前window中更新
+(void) showNotifitationInWindow:(NSString *)text;
//有偏移量的
+(void) showNotifitationInWindowOffset:(NSString *)text;

//有偏移量
+ (void)showNotifitation:(NSString *)text toView:(UIView *)view  withYoffset:(CGFloat)yOffset;

//显示文字提示
+ (void)showNotifitation:(NSString *)text toView:(UIView *)view;

//显示等待中
+ (void)showWaitInfo:(NSString *)text toView:(UIView *)view;

+ (void)hideHudFromView:(UIView *)view;

+(void) showWaitInfoInWindow:(NSString *) hint;

+(void) hidenHubFromWindow;

@end
