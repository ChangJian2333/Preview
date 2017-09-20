//
//  CommonZoomingImgView.h
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonZoomingImgView : UIView

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIView *hudView;

@property (nonatomic, assign) CGRect imgFrame;

@property (nonatomic, strong) UIImage *image;

// 长按图片
@property (nonatomic, strong) void (^didLongTapImgViewClick)();

// 点击图片
@property (nonatomic, strong) void (^didTapImgViewClick)();

// 设置动画frame
-(void)setAnimationFrame;

@end
