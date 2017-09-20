//
//  CommonImagePreview.h
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewDefine.h"

@interface CommonImagePreview : UIView

@property (nonatomic, assign) PreviewType type;

- (void)showWithImageViews:(NSArray*)views showWithViewController:(UIViewController *)showVC selectedView:(UIImageView*)selectedView type:(PreviewType)type;

// 有收藏和投诉功能
-(void)showWithImageViews:(NSArray*)views showWithViewController:(UIViewController *)showVC selectedView:(UIImageView*)selectedView type:(PreviewType)type infoDict:(NSMutableDictionary *)info;

@end
