//
//  CommonImagePreview.m
//  Mobileyx
//
//  Created by 常见 on 2017/9/7.
//  Copyright © 2017年 youhui. All rights reserved.
//

#import "CommonImagePreview.h"
#import "CommonZoomingImgView.h"
#import "YXCommonUtil.h"
#import "UIImageView+WebCache.h"

@interface CommonImagePreview ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *scrollSubViewArray; // 所有预览的图片View集合(原图)

@property (nonatomic, strong) NSMutableArray *imgViews; // 所有预览的图片View集合(非原图)

@property (nonatomic, weak) UIViewController *showVC; // 显示预览图片的控制器

@property (nonatomic, strong) NSMutableArray *offsetArray;  // showVC上的scrollView的偏移量集合

@property (nonatomic, strong) NSMutableArray *scrollArray; // showVC上的scrollView集合

@property (nonatomic ,assign) BOOL showVcDefultTabbarHidden; // 记录是否隐藏tabbar

@property (nonatomic, assign) CGFloat topSearchBarAlpha; // 记录topsearchbar状态

@property (nonatomic, assign) UIBarStyle navgationBarStyle; // 记录barStyle;

// 收藏投诉信息
@property (nonatomic, strong) NSMutableDictionary *infoDict;

@property (nonatomic, assign) BOOL isArtWork; // 是否是原图

@end

@implementation CommonImagePreview
-(void)dealloc
{
    NSLog(@"CommonImagePreview销毁...");
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    self.backgroundColor = [UIColor blackColor];
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.scrollView];
    
}

-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 42, [UIScreen mainScreen].bounds.size.width, 32)];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.3];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

-(NSMutableArray *)offsetArray
{
    if (_offsetArray == nil) {
        _offsetArray = [NSMutableArray array];
    }
    return _offsetArray;
}

-(NSMutableArray *)scrollArray
{
    if (_scrollArray == nil) {
        _scrollArray = [NSMutableArray array];
    }
    return _scrollArray;
}

-(NSMutableArray *)scrollSubViewArray
{
    if (_scrollSubViewArray == nil) {
        _scrollSubViewArray = [NSMutableArray array];
    }
    return _scrollSubViewArray;
}

// 有收藏和投诉功能
-(void)showWithImageViews:(NSArray*)views showWithViewController:(UIViewController *)showVC selectedView:(UIImageView*)selectedView type:(PreviewType)type infoDict:(NSMutableDictionary *)info
{
    self.infoDict = info;
    [self showWithImageViews:views  showWithViewController:showVC selectedView:selectedView type:type];
}

// 无收藏和投诉功能
- (void)showWithImageViews:(NSArray*)views showWithViewController:(UIViewController *)showVC selectedView:(UIImageView*)selectedView type:(PreviewType)type
{
    
    for (UIView *view in showVC.view.subviews) { // 保存showVC中的scrollView 和对应的offset
        if ([view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UITableView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            [self.offsetArray addObject:NSStringFromCGPoint(scrollView.contentOffset)];
            [self.scrollArray addObject:scrollView];
        }
    }
    
//    for (UIView *view in showVC.navigationController.navigationBar.subviews) { // 记录navigationBar的状态
//        if ([view isKindOfClass:[CommonTopSearchBarView class]]) {
//            self.topSearchBarAlpha = view.alpha;
//            self.navgationBarStyle = showVC.navigationController.navigationBar.barStyle;
//        }
//    }
    
    self.type = type;
    self.showVC = showVC;
    self.showVcDefultTabbarHidden = self.showVC.tabBarController.tabBar.hidden;
    self.showVC.tabBarController.tabBar.hidden = YES;
    
    [showVC.view addSubview:self];
    self.imgViews = [views mutableCopy];
    const NSInteger currentPage = [self.imgViews indexOfObject:selectedView];
    
    if (views.count > 1) {
        [self addSubview:self.pageControl];
        self.pageControl.numberOfPages = views.count;
        self.pageControl.currentPage = currentPage;
    }
    
    [showVC.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self setScrollViewSubviewsAndAnimation];
}
// 判断是否已经缓存
-(BOOL)imageIsCacheWith:(NSURL*)url
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    return [manager diskImageExistsForURL:[NSURL URLWithString:[self artworkWith:url]]];
}

// 获取原图链接
-(NSString *)artworkWith:(NSURL *)url
{
    NSString *imagePath = [url absoluteString];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"@!100px_db" withString:@""];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"@!160px_db" withString:@""];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"@!250px_db" withString:@""];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"@!828px_db" withString:@""];
    //    if (![imagePath containsString:@"http"]) {
    //        imagePath = [NSString stringWithFormat:@"http://yxck.img-cn-beijing.aliyuncs.com/%@",imagePath];
    //    }
    return imagePath;
}

// 设置图片 和动画
-(void)setScrollViewSubviewsAndAnimation
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    
    _scrollView.contentSize = CGSizeMake(self.imgViews.count * fullW, 0);
    _scrollView.contentOffset = CGPointMake(self.pageControl.currentPage * fullW, 0);
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)];
    [_scrollView addGestureRecognizer:gesture];
    
    for (int i = 0; i < self.imgViews.count; i++) {
        UIImageView *view = self.imgViews[i];
        CommonZoomingImgView *tmp = [[CommonZoomingImgView alloc] initWithFrame:CGRectMake([self.imgViews indexOfObject:view] * fullW, 0, fullW, fullH)];
        CGRect frame = [self convertRect:view.frame fromView:view.superview];
        frame.origin.x = ([UIScreen mainScreen].bounds.size.width - frame.size.width)/2;
        frame.origin.y = ([UIScreen mainScreen].bounds.size.height - frame.size.height)/2;
        tmp.imgFrame = frame;
        NSString *imgPath = [view.sd_imageURL absoluteString];
        if (imgPath.length > 0) { // 显示网络图片
            if (![self imageIsCacheWith:view.sd_imageURL]) { // 还未缓存
                [YXCommonUtil showWaitInfo:@"" toView:tmp.hudView];
            }
            [UIView animateWithDuration:0.3 animations:^{
                [tmp setAnimationFrame];
            }];
            NSString *url = [NSString stringWithFormat:@"%@/PreviewArtwork",imgPath];
            [tmp.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:view.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [YXCommonUtil hideHudFromView:tmp.hudView];
            }];
        }else{    // 显示本地图片
            tmp.image = view.image;
            [UIView animateWithDuration:0.3 animations:^{
                [tmp setAnimationFrame];
            }];
        }
        
        
        [self zoomImgViewBlockClick:tmp];
        [self.scrollView addSubview:tmp];
        [self.scrollSubViewArray addObject:tmp];
    }
}

-(void)zoomImgViewBlockClick:(CommonZoomingImgView *)imgView
{
    typeof(self) __weak weakSelf = self;
    // 图片点击
    [imgView setDidTapImgViewClick:^{
        [weakSelf dismissWithAnimate];
    }];
    // 图片长按
    [imgView setDidLongTapImgViewClick:^{
        [weakSelf showImgViewLongTapClick];
    }];
}

// 图片长按事件
-(void)showImgViewLongTapClick
{
    if (self.type == kPreviewTypeNone) { // 不需要长按手势
        return;
    }
    // 默认为原图
    self.isArtWork = YES;
    NSData *imgData = UIImageJPEGRepresentation([self getCurrentImage], 1);
    CGFloat len = (CGFloat)imgData.length/1024/1024;
//    CSActionSheet *actionSheet = [[CSActionSheet alloc] initWithNewTitle:nil CSActionSheetType:kCSActionSheetTypeImageLongTap delegate:self inputParam:@{@"imageLength":[NSString stringWithFormat:@"  原图%0.2fM",len]} cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送给朋友",@"保存图片",@"收藏", nil]; //@"发送给朋友",@"保存图片",@"收藏",@"识别图中二维码"
//    
//    [actionSheet show];
}

// 取出显示的图片
-(UIImage *)getCurrentImage
{
    UIImage *selectImage ;
    if (self.isArtWork) { // 原图
        CommonZoomingImgView *currentView = self.scrollSubViewArray[self.pageControl.currentPage];
        selectImage = currentView.image;
    }else{
        UIImageView *currentView = self.imgViews[self.pageControl.currentPage];
        selectImage = currentView.image;
    }
    return selectImage;
}

#pragma mark- Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimate];
}

// 预览结束
-(void)dismissWithAnimate
{
    self.showVC.tabBarController.tabBar.hidden = self.showVcDefultTabbarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.showVC.navigationController setNavigationBarHidden:NO animated:NO];
    
//    for (UIView *view in self.showVC.navigationController.navigationBar.subviews) {
//        if ([view isKindOfClass:[CommonTopSearchBarView class]]) {
//            view.alpha = self.topSearchBarAlpha;
//            self.showVC.navigationController.navigationBar.barStyle = self.navgationBarStyle;
//        }
//    }
    UIImageView *currentImgView = self.imgViews[self.pageControl.currentPage];
    CGRect frame = [self convertRect:currentImgView.frame fromView:currentImgView.superview];
    for (int i = 0; i < self.scrollArray.count; i++) {
        UIScrollView *scrollView = self.scrollArray[i];
        CGPoint point = CGPointFromString(self.offsetArray[i]);
        if (scrollView.contentOffset.y < point.y) { // 当tableView 再最底层时
            frame.origin.y -= point.y - scrollView.contentOffset.y;
        }
        scrollView.contentOffset = point;
    }
    CommonZoomingImgView *dismissImgView = self.scrollSubViewArray[self.pageControl.currentPage];
    [UIView animateWithDuration:0.2 animations:^{
        //        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        dismissImgView.imgFrame = frame;
        dismissImgView.hudView.hidden = YES;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)didPan:(UIPanGestureRecognizer *)sender {
    [self dismissWithAnimate];
    
}


#pragma mark - UIScrllViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    self.pageControl.currentPage = currentPage;
}



@end
