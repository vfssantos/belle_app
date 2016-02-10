//
//  FeedbackDetailViewController.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "FeedbackDetailViewController.h"
#import "SettingViewController.h"
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"
@interface FeedbackDetailViewController ()

@end

@implementation FeedbackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FEEDBACK";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    if([self.mineStr  isEqual: @"yes"])
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Trash-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteLook)];
    else
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goSetting)];
    
    CGRect frmImg = mainImgView.frame;
    frmImg.size.height = [UIScreen mainScreen].bounds.size.width*0.8;
    frmImg.size.width = [UIScreen mainScreen].bounds.size.width*0.8;
    frmImg.origin.x =([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width*0.8)/2;
    
    mainImgView.frame = frmImg;
    
    frmImg = feedbackView.frame;
    frmImg.size.width = [UIScreen mainScreen].bounds.size.width;
    frmImg.origin.y = (mainImgView.frame.origin.y+mainImgView.frame.size.height+[UIScreen mainScreen].bounds.size.height)/2-115;
    feedbackView.frame = frmImg;
    
    
    [self displayLook];
}
- (void)deleteLook{
    /*Action = deletePhoto
     o Mandatory field
     ent_sess_token
     ent_dev_id
     photo_id*/
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"photo_id":self.lookDetailDic[@"pid"]};
    
    NSLog(@"deletePhoto Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/deletePhoto" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"deletePhoto JSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [[[UIAlertView alloc] initWithTitle:[responseObject objectForKey:@"errMsg"]
                                        message:@""
                                       delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

    
}
- (void)displayLook{
    [mainImgView setImageWithURL:[NSURL URLWithString:self.lookDetailDic[@"url"]] placeholderImage:nil];
    likeLbl.text = self.lookDetailDic[@"likes"];
    dislikeLbl.text = self.lookDetailDic[@"dislikes"];
    wldVwLbl.text = self.lookDetailDic[@"views"];
    fvrtLbl.text = self.lookDetailDic[@"favs"];
}
- (void)goSetting{
    SettingViewController *sub = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
