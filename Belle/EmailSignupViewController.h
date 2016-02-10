//
//  EmailSignupViewController.h
//  Belle
//
//  Created by herocule on 9/14/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailSignupViewController : UIViewController
{
    NSString *gender;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *psswdTxt;
    IBOutlet UITextField *cnfmPsswdTxt;
    IBOutlet UIButton *signupBttn;
    IBOutlet UIImageView *female_indImgView;
    IBOutlet UIImageView *male_indImgView;
}
- (IBAction)click_femaleBttn:(UIButton *)sender;
- (IBAction)click_maleBttn:(id)sender;
- (IBAction)click_signupBttn:(UIButton *)sender;
@end
