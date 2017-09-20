//
//  UIViewController+Preview.h
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewDefine.h"

@interface UIViewController (Preview)

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type;;


- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type infoDict:(NSMutableDictionary *)info;

@end
