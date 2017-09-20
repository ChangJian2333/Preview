//
//  CommonZoomingImgView.m
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import "CommonZoomingImgView.h"

@interface CommonZoomingImgView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation CommonZoomingImgView


-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.contentOffset = CGPointZero;
    [self addSubview:self.scrollView];
    
    self.hudView = [[UIView alloc] init];
    self.hudView.backgroundColor = [UIColor clearColor];
    self.hudView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, [UIScreen mainScreen].bounds.size.height/2 - 40, 80, 80);
    self.hudView.userInteractionEnabled = NO;
    [self addSubview:self.hudView];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.clipsToBounds = YES;
    self.imgView.userInteractionEnabled = YES;
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.imgView];
    
    UITapGestureRecognizer *tapSelfRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longRecognizer:)];
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapRecognizer:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.delegate = self;
    [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.imgView addGestureRecognizer:tapRecognizer];
    [self.imgView addGestureRecognizer:longRecognizer];
    [self.imgView addGestureRecognizer:doubleTapRecognizer];
    [self addGestureRecognizer:tapSelfRecognizer];
}

-(void)setImage:(UIImage *)image
{
    self.imgView.image = image;
    if (image.size.width > image.size.height) {
        self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

-(UIImage *)image
{
    return self.imgView.image;
}

-(void)setImgFrame:(CGRect)imgFrame
{
    self.imgView.frame = imgFrame;
}

-(void)setAnimationFrame
{
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.frame = self.bounds;
}

// 点击
-(void)tapRecognizer:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"top.....");
    if (self.didTapImgViewClick) {
        if (!(self.scrollView.zoomScale == 1)) {
            self.scrollView.zoomScale = 1;
        }
        self.didTapImgViewClick();
    }
}
// 长按
-(void)longRecognizer:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
    NSLog(@"Longtop.....");
    if (self.didLongTapImgViewClick) {
        self.didLongTapImgViewClick();
    }
}
// 双击
-(void)doubleTapRecognizer:(UITapGestureRecognizer *)recognizer
{
    CGFloat zoomScale = self.scrollView.zoomScale;
    zoomScale = (zoomScale == 1.0) ? 2.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[recognizer locationInView:recognizer.view]];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

#pragma mark- Scrollview delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}


@end
