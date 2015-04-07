//
//  MainViewController.m
//  WaterMonitor
//
//  Created by AKI on 2015/3/31.
//  Copyright (c) 2015年 AKI. All rights reserved.
//

#import "MainViewController.h"

#define VponID @"8a8081824c6e3a77014c700120de079e"

#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewTest;

@end

@implementation MainViewController
@synthesize dataArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[ContainerView bounds]];
    
    view1 = [[WaterViewController alloc] initWithNibName:@"WaterViewController" bundle:nil];
    
    view1.mArray = dataArray;
    
    
    view2 = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    view2.mArray = dataArray;
    
    viewControllers =[NSArray arrayWithObject:view1];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [ContainerView addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
        }
    }

    
    CGPoint origin = CGPointMake(([UIScreen mainScreen].bounds.size.width-CGSizeFromVpadnAdSize(VpadnAdSizeBanner).width)/2,0.0);
    vpadnAd = [[VpadnBanner alloc] initWithAdSize:VpadnAdSizeBanner origin:origin];
    vpadnAd.strBannerId = VponID;   // 填入您的BannerId
    vpadnAd.delegate = self;
    vpadnAd.platform = @"TW"; //
    [vpadnAd setAdAutoRefresh:YES];
    [vpadnAd setRootViewController:self];
    [adView addSubview:[vpadnAd getVpadnAdView]];
    [vpadnAd startGetAd:[self getTestIdentifiers]];
    [self doButtonState:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIViewController *currentView = [self.pageController.viewControllers objectAtIndex:0];
    
    if ([currentView isKindOfClass:[view1 class]]) {
        [UIView animateWithDuration:0.24f animations:^{
            [selectedBar setFrame:CGRectMake(btnWater.frame.origin.x-3, selectedBar.frame.origin.y, selectedBar.frame.size.width, selectedBar.frame.size.height)];
        } completion:^(BOOL finished) {
            
            [self doButtonState:1];
        }];
    }
    else if([currentView isKindOfClass:[view2 class]]){
        [UIView animateWithDuration:0.24f animations:^{
            [selectedBar setFrame:CGRectMake(btnSetting.frame.origin.x-3, selectedBar.frame.origin.y, selectedBar.frame.size.width, selectedBar.frame.size.height)];
        } completion:^(BOOL finished) {
            
            [self doButtonState:1];
        }];
    }
   
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    if ([[viewController class] isSubclassOfClass:[view1 class]]) {
        return nil;
    }
    
    if([[viewController class] isSubclassOfClass:[view2 class]]){
        return view1;
    }
    
    return nil;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if([[viewController class] isSubclassOfClass:[view1 class]]){
        return view2;
    }
    
    return nil;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}




-(IBAction)btnWater:(id)sender{
    [self.pageController setViewControllers:[NSArray arrayWithObject:view1] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [UIView animateWithDuration:0.24f animations:^{
        [selectedBar setFrame:CGRectMake(btnWater.frame.origin.x, selectedBar.frame.origin.y, selectedBar.frame.size.width, selectedBar.frame.size.height)];
    } completion:^(BOOL finished) {
        
        [self doButtonState:0];
        
        
    }];
    
  
    

    
}


-(IBAction)btnSetting:(id)sender{
    
    [self.pageController setViewControllers:[NSArray arrayWithObject:view2] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [UIView animateWithDuration:0.24f animations:^{
        [selectedBar setFrame:CGRectMake(btnSetting.frame.origin.x, selectedBar.frame.origin.y, selectedBar.frame.size.width, selectedBar.frame.size.height)];
    } completion:^(BOOL finished) {
        
        [self doButtonState:1];
    }];
    
}

-(void)doButtonState:(int)idx{
    if(idx==0){
        [btnWater setBackgroundColor:RGBCOLOR(0,128,255)];
        [btnSetting setBackgroundColor:[UIColor whiteColor]];
        
        [btnWater setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSetting setTitleColor:RGBCOLOR(0,128,255) forState:UIControlStateNormal];
    }else{
        
        [btnSetting setBackgroundColor:RGBCOLOR(0,128,255)];
        [btnWater setBackgroundColor:[UIColor whiteColor]];
        
        [btnSetting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnWater setTitleColor:RGBCOLOR(0,128,255) forState:UIControlStateNormal];

    }
}

#pragma mark -------------------------------------------
#pragma mark Vpon



// 請新增此function到您的程式內 如果為測試用 則在下方填入UUID，即可看到測試廣告。
-(NSArray*)getTestIdentifiers
{
    return [NSArray arrayWithObjects:nil];
}

#pragma mark VponAdDelegate method 接一般Banner廣告就需要新增
- (void)onVponAdReceived:(UIView *)bannerView{
    NSLog(@"廣告抓取成功");
}

- (void)onVponAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"廣告抓取失敗");
}

- (void)onVponPresent:(UIView *)bannerView{
    NSLog(@"開啟vpon廣告頁面 %@",bannerView);
}

- (void)onVponDismiss:(UIView *)bannerView{
    NSLog(@"關閉vpon廣告頁面 %@",bannerView);
}

- (void)onVponLeaveApplication:(UIView *)bannerView{
    NSLog(@"離開publisher application");
}

#pragma mark VponInterstitial Delegate 有接Interstitial的廣告才需要新增
- (void)onVponInterstitialAdReceived:(UIView *)bannerView{
    NSLog(@"插屏廣告抓取成功");
    // 顯示插屏廣告
    [vponInterstitial show];
}

- (void)onVponInterstitialAdFailed:(UIView *)bannerView{
    NSLog(@"插屏廣告抓取失敗");
}

- (void)onVponInterstitialAdDismiss:(UIView *)bannerView{
    NSLog(@"關閉插屏廣告頁面 %@",bannerView);
}

#pragma mark 通知關閉vpon開屏廣告
- (void)onVponSplashAdDismiss{
    NSLog(@"關閉vpon開屏廣告頁面");
}

#pragma mark -------------------------------------------



@end
