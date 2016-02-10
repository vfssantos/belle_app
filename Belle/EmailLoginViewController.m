//
//  EmailLoginViewController.m
//  Belle
//
//  Created by herocule on 9/14/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "EmailLoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"

#import "HomeViewController.h"
#import "CameraViewController.h"
#import "FeedbackViewController.h"
#import "LooksViewController.h"
#import "BaseTabBarViewController.h"

@interface EmailLoginViewController ()

@end

@implementation EmailLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"LOGIN";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    emailTxt.layer.cornerRadius = 4;
    psswdTxt.layer.cornerRadius = 4;
    loginBttn.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (IBAction)click_loginBttn:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if(![emailTxt.text  isEqual: @""] && ![psswdTxt.text  isEqual: @""]){
        if(![self validateEmail:emailTxt.text]){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid email"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        [self LoginToServer];
    }

}

- (void)LoginToServer{
    /*Action = login
     o Mandatory field
     
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
    [MBProgressHUD showMessag:@"Loading..." toView:self.view];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_email":emailTxt.text,
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"ent_device_type":@"1",
                                 @"ent_push_token":@"temp_pushtoken",
                                 @"ent_auth_type":@"2",
                                 @"ent_password":psswdTxt.text
                                 };
    
    NSLog(@"localLogin Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"localLoginJSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            
            [defaults setObject:[responseObject objectForKey:@"token"] forKey:@"belle_token"];
            [defaults setObject:@"2" forKey:@"auth_type"];
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
- (void) gotoMainPage{
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
