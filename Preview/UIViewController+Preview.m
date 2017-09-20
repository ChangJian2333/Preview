//
//  UIViewController+Preview.m
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import "UIViewController+Preview.h"
#import "CommonImagePreview.h"
#import <objc/runtime.h>


@interface UIViewController ()

@end

@implementation UIViewController (Preview)

static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([UIViewController class] ,@selector(viewWillAppear:), @selector(previewSwizzling_viewWillAppear:));
    });
}

-(void)previewSwizzling_viewWillAppear:(BOOL)animated
{
    [self previewSwizzling_viewWillAppear:animated];
    for (UIView *view in self.view.subviews) {
        if ([[view class] isSubclassOfClass:[CommonImagePreview class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
        }
    }
}



- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type
{
    for (UIView *view in self.view.subviews) {
        if ([[view class] isSubclassOfClass:[CommonImagePreview class]]) {
            return;
        }
    }
    CommonImagePreview *preview = [[CommonImagePreview alloc] init];
    [self.view addSubview:preview];
    [preview showWithImageViews:views showWithViewController:self selectedView:selectedView type:type];
}

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type infoDict:(NSMutableDictionary *)info
{
    for (UIView *view in self.view.subviews) {
        if ([[view class] isSubclassOfClass:[CommonImagePreview class]]) {
            return;
        }
    }
    CommonImagePreview *preview = [[CommonImagePreview alloc] init];
    [self.view addSubview:preview];
    [preview showWithImageViews:views showWithViewController:self selectedView:selectedView type:type infoDict:info];
}


@end
