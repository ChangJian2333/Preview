//
//  UIView+Preview.h
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewDefine.h"

@interface UIView (Preview)

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type;

/**
 *  有投诉收藏功能
 *
 *  @param views         需要预览的imgViewArry
 *  @param selectedView  首先预览的imgView
 */
- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView type:(PreviewType)type infoDict:(NSMutableDictionary *)info;


@end
