//
//  YXCommonUtil.m
//  Mobileyx
//
//  Created by 常见 on 2017/8/15.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import "YXCommonUtil.h"
#import "MBProgressHUD.h"

@implementation YXCommonUtil

+(BOOL)isNumber:(NSString *)number
{
    NSString *nameREgex = @"^[0-9]+([.]{0}|[.]{1}[0-9]+)$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nameREgex];
    return [nameTest evaluateWithObject:number];
}

/**
 *  获取当前窗口rootViewController
 */
+(UIViewController *)rootViewController
{
    return [[UIApplication sharedApplication].delegate window].rootViewController;
}

/**
 *  获取当前窗口最上层viewcontroller
 */
+(UIViewController *)topViewController
{
    id rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        // 导航控制器，获取控制器中最上层viewController
        UINavigationController *naVc = (UINavigationController *)rootViewController;
        rootViewController = naVc.topViewController;
        if([rootViewController isKindOfClass:[UITabBarController class]]){
            // TabBar控制器，获取当前选中viewController
            rootViewController = [(UITabBarController *)rootViewController selectedViewController];
            if ([rootViewController isKindOfClass:[UINavigationController class]]) {
                // 当前选中为导航控制器，获取控制器中最上层viewController
                UINavigationController *naVc = (UINavigationController *)rootViewController;
                while ([naVc.presentedViewController isKindOfClass:[UINavigationController class]]) {
                    naVc = (UINavigationController *)naVc.presentedViewController;
                }
                return naVc.topViewController;
            } else {
                // 不是导航控制器，直接返回
                return ((UIViewController *)rootViewController);
            }
        } else {
            return naVc.topViewController;
        }
    } else if([rootViewController isKindOfClass:[UITabBarController class]]){
        // TabBar控制器，获取当前选中viewController
        rootViewController = [(UITabBarController *)rootViewController selectedViewController];
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            // 当前选中为导航控制器，获取控制器中最上层viewController
            UINavigationController *naVc = (UINavigationController *)rootViewController;
            return naVc.topViewController;
        } else {
            // 不是导航控制器，直接返回
            return ((UIViewController *)rootViewController);
        }
    } else {
        // 不是导航控制器，直接返回
        return ((UIViewController *)rootViewController);
    }
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]] && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}


+(void) showNotifitationInWindow:(NSString *)text{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = text;
    hud.margin = 10.f;
    hud.minShowTime = 0.3f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:2];
}

+(void) showNotifitationInWindowOffset:(NSString *)text
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = text;
    hud.margin = 10.f;
    hud.minShowTime = 0.3f;
    hud.yOffset=( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )?(-35):0;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)showNotifitation:(NSString *)text toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = text;
    hud.margin = 10.f;
    hud.minShowTime = 0.3f;
    //    hud.yOffset = 1.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:2];
}
+ (void)showNotifitation:(NSString *)text toView:(UIView *)view  withYoffset:(CGFloat)yOffset{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = nil;
    hud.detailsLabel.text = text;
    hud.margin = 10.f;
    hud.minShowTime = 0.3f;
    hud.yOffset = yOffset;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)showWaitInfo:(NSString *)text toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (text && text.length > 0) {
        hud.label.text = text;
    }
    hud.margin = 10.f;
    hud.minShowTime = 0.3f;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideHudFromView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+(void) showWaitInfoInWindow:(NSString *) hint{
    [self showWaitInfo:hint toView:[[UIApplication sharedApplication].delegate window]];
}

+(void) hidenHubFromWindow{
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
}


@end
