//
//  TabBarViewController.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "TabBarViewController.h"
#import "SCNavigationController.h"
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    if ([[UIScreen mainScreen] bounds].size.height > 700) {
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_tabbar_6p"]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"act_bg_tabbar_6p"]];
    } else if ([[UIScreen mainScreen] bounds].size.height > 600) {
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_tabbar_6"]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"act_bg_tabbar_6"]];
    } else {
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_tabbar_5"]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"act_bg_tabbar_5"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController*) viewController:(UIViewController*)vwController TabTitle:(NSString*) title image:(UIImage*)image
{
    vwController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
    return vwController;
}
-(void) hiddenCameraBttn:(NSNotification*)notification
{
    if ([[notification.userInfo objectForKey:@"info"]  isEqual: @"1"]) button.hidden = FALSE;
    else button.hidden = TRUE;
}
// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width/4, 50);
    [button setBackgroundColor:[UIColor clearColor]];
    NSLog(@"%f",self.tabBar.frame.size.height);
    [button addTarget:self action:@selector(click_cameraBttn) forControlEvents:UIControlEventTouchUpInside];
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        
        button.center = center;
    }
    button.tag =1212;
    CGPoint center = button.center;
    center.x = center.x - [UIScreen mainScreen].bounds.size.width/8;
    button.center = center;
    [self.view addSubview:button];
}
- (void)click_cameraBttn{
    SCNavigationController *nav = [[SCNavigationController alloc] init];
    //    nav.scNaigationDelegate = self;
    [nav showCameraWithParentController:self];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
