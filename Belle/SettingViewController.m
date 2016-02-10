//
//  SettingViewController.m
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
@interface SettingViewController ()<UIWebViewDelegate>
{
    UIWebView *pWebview ;
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CONFIGURATION";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"logout"] style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    pWebview = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [pWebview sizeToFit];
    pWebview.scrollView.scrollEnabled = YES;
    pWebview.delegate = self;
    
    pWebview.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:pWebview];
    
    pWebview.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *url = [NSURL URLWithString:@"http://159.203.235.29/terms_of_use.php"];
    [pWebview loadRequest:[NSURLRequest requestWithURL:url]];
    
    

}
- (void)logout{
    /*Action = logout
    o Mandatory field
    ent_sess_token
    ent_dev_id*/
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters =@{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    NSLog(@"fbLogin Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/logout" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"belle_loginFlg"];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate removeSplash];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];

    
    }
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenCameraBttn" object:self userInfo:@{@"info":@"0"}];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hiddenCameraBttn" object:self userInfo:@{@"info":@"1"}];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIView beginAnimations:nil context:nil];
    
    pWebview.hidden = NO;
    
    [UIView commitAnimations];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


@end
