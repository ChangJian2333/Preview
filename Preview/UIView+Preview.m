//
//  UIView+Preview.m
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import "UIView+Preview.h"
#import "YXCommonUtil.h"
#import "CommonImagePreview.h"

@implementation UIView (Preview)
- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type
{
    for (UIView *view in [YXCommonUtil topViewController].view.subviews) {
        if ([[view class] isSubclassOfClass:[CommonImagePreview class]]) {
            return;
        }
    }
    CommonImagePreview *preview = [[CommonImagePreview alloc] init];
    [preview showWithImageViews:views showWithViewController:[YXCommonUtil topViewController] selectedView:selectedView type:type];
    
    
}

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type infoDict:(NSMutableDictionary *)info
{
    for (UIView *view in [YXCommonUtil topViewController].view.subviews) {
        if ([[view class] isSubclassOfClass:[CommonImagePreview class]]) {
            return;
        }
    }
    CommonImagePreview *preview = [[CommonImagePreview alloc] init];
    [preview showWithImageViews:views showWithViewController:[YXCommonUtil topViewController] selectedView:selectedView type:type infoDict:info];
}

@end
