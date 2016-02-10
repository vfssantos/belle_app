//
//  SignInViewController.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//
#define thumb_color [UIColor colorWithRed:99/255.0f green:159/255.0f blue:213/255.0f alpha:1.0f]

#import "SignInViewController.h"

#import "HomeViewController.h"
#import "CameraViewController.h"
#import "FeedbackViewController.h"
#import "LooksViewController.h"
#import "BaseTabBarViewController.h"
#import "EmailLoginViewController.h"
#import "EmailSignupViewController.h"



#import "FBLoginHandler.h"
#import "MBProgressHUD+Add.h"
#import "AFNetworking.h"
@interface SignInViewController ()<FBLoginHandlerDelegate>

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    emailSigninBttn.layer.cornerRadius = 4;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)click_fbSignInBttn:(UIButton *)sender {
    FBLoginHandler *fbLoginHandler = [FBLoginHandler sharedInstance];
    fbLoginHandler.delegate = self;
    [fbLoginHandler loginWithFacebook];
    [MBProgressHUD showMessag:@"Loading..." toView:self.view];
    
    
//    [self gotoMainPage];
}
- (void)didFacebookUserLogout:(BOOL)logout{
    
}

-(void)didFacebookUserLogin:(BOOL)login withDetail:(NSDictionary *)userInfo{
    if (login)
    {
        //        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        NSLog(@"Do something when user is loggin with data %@",userInfo);
        
        
        ent_first_name = [NSString stringWithFormat:@"%@",userInfo[@"FirstName"] ];
        ent_last_name = [NSString stringWithFormat:@"%@",userInfo[@"LastName"] ];
        ent_email = [NSString stringWithFormat:@"%@",userInfo[@"Email"]];
        ent_gender = [[NSString stringWithFormat:@"%@",userInfo[@"Gender"]]  isEqual: @"male"] ? @"1" : @"2";
        ent_fbid = [NSString stringWithFormat:@"%@",userInfo[@"FacebookId"]];
        
        [FBRequestConnection startWithGraphPath:@"/me/friends?fields=id"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  
                                  
                                  if(error) {
                                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                      return;
                                  }
                                  [FBSession.activeSession close];
                                  [FBSession.activeSession closeAndClearTokenInformation];
                                  NSArray* collection = (NSArray*)[result data];
                                  NSLog(@"==========================%@", collection);
                                  [self LoginToServer:collection];
                              }];

        
        
    }
    else [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
-(void)didFacebookUserLoginFail{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)LoginToServer:(NSArray*)contactArray{
    /*Action = login
     o Mandatory field
     ent_first_name
     ent_last_name
     ent_fbid
     ent_email
     ent_dev_id
     ent_device_type(1 - apple, 2 - android)
     ent_push_token
     ent_auth_type
     ent_auth_type = '1' => ent_fb_id, ent_gender
     ent_auth_type = '2' => ent_password
     ent_auth_type = '3' => ent_password, ent_gender
     o General field
     ent_friends(fbid ',' separate )*/
    
    NSMutableString * contactStr = [[NSMutableString alloc] init];
    if(contactArray.count > 0) {
        for (int i=0; i<contactArray.count-1; i++)
        {
            [contactStr appendString:[NSString stringWithFormat:@"%@,",contactArray[i][@"id"]]];
        }
        [contactStr appendString:[NSString stringWithFormat:@"%@",contactArray[contactArray.count-1][@"id"]]];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_email":ent_email,
                       @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                       @"ent_device_type":@"1",
                       @"ent_push_token":@"temp_pushtoken",
                       @"ent_fb_id":ent_fbid,
                       @"ent_first_name":ent_first_name,
                       @"ent_last_name":ent_last_name,
                       @"ent_friends":contactStr,
                       @"ent_auth_type":@"1",
                        @"ent_gender":ent_gender
                       };
    
    NSLog(@"fbLogin Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"fbLoginJSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            
            [defaults setObject:[responseObject objectForKey:@"token"] forKey:@"belle_token"];
            [defaults setObject:@"1" forKey:@"auth_type"];
            [defaults setObject:@"yes" forKey:@"belle_loginFlg"];
            
            [self gotoMainPage];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        else{
            [[[UIAlertView alloc] initWithTitle:[responseObject objectForKey:@"errMsg"]
                                        message:@""
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (IBAction)click_emailsigninBttn:(UIButton *)sender {
    EmailLoginViewController *sub = [[EmailLoginViewController alloc] init];
    
    [self.navigationController pushViewController:sub animated:YES];
}

- (IBAction)click_emailSignupBttn:(UIButton *)sender {
    EmailSignupViewController *sub = [[EmailSignupViewController alloc] init];
    
    [self.navigationController pushViewController:sub animated:YES];
}
- (void) gotoMainPage{
    //Precisei colocar a linha abaixo para fechar o UIWebView após confirmado o login pelo Facebook
    [self dismissModalViewControllerAnimated:YES];
    
    HomeViewController *homeView = [[HomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    CameraViewController *searchView = [[CameraViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:searchView];
    
    FeedbackViewController *notificationView = [[FeedbackViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:notificationView];
    
    LooksViewController *profileView = [[LooksViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:profileView];
    
    NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  nav1,
                                  nav2,
                                  nav3,
                                  nav4,nil];
    BaseTabBarViewController *sub = [[BaseTabBarViewController alloc] init];
    [sub setViewControllers:myViewControllers];
    
    [self presentViewController:sub animated:YES completion:nil];
    


}
@end
