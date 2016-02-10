//
//  PostViewController.m
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "PostViewController.h"


#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainImgView.image = self.mainImg;
    optionStr = @"1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)click_optionBttn:(UIButton *)sender {
    if(sender.tag == 301){
        optionStr = @"1";
        optionFrdImgView.image = [UIImage imageNamed:@"option_act"];
        optionWrdImgView.image = [UIImage imageNamed:@"option_inact"];
    }
    else{
        optionStr = @"2";
        optionFrdImgView.image = [UIImage imageNamed:@"option_inact"];
        optionWrdImgView.image = [UIImage imageNamed:@"option_act"];
    }
}

- (IBAction)click_confirmBttn:(UIButton *)sender {
    
    [self postToServer];
}

- (IBAction)click_backBttn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)click_cancelBttn:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)postToServer{
    /*Action = addPhoto
     o Mandatory field
     ent_sess_token
     ent_dev_id
     pt_option(1- frined, 2 - world)
     o file
     share_photo*/
    
    [MBProgressHUD showMessag:@"Please Wait..." toView:self.view];
    
    
    NSData *imageData = [[NSData alloc] init];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(400, 400), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    [mainImgView.image drawInRect:CGRectMake(0, 0, 400, 400)];
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    imageData = UIImageJPEGRepresentation(outputImage, 0.9);
   

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"pt_option":optionStr
                                 };
    
    NSLog(@"addPhoto Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/addPhoto" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imageData != nil) {
            [formData appendPartWithFileData:imageData name:@"share_photo" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
        
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"addPhoto JSON: %@", responseObject);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            [[[UIAlertView alloc] initWithTitle:@"Your Look has posted successfully."
                                    message:@""
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}

@end
