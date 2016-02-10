//
//  EmailLoginViewController.h
//  Belle
//
//  Created by herocule on 9/14/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailLoginViewController : UIViewController
{
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *psswdTxt;
    IBOutlet UIButton *loginBttn;
}
- (IBAction)click_loginBttn:(UIButton *)sender;
@end
