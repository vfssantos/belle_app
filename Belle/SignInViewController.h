//
//  SignInViewController.h
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController
{
    NSString *ent_first_name, *ent_last_name, *ent_fbid, *ent_email, *ent_gender;
    IBOutlet UIButton *emailSigninBttn;
    
}
- (IBAction)click_fbSignInBttn:(UIButton *)sender;
- (IBAction)click_emailsigninBttn:(UIButton *)sender;
- (IBAction)click_emailSignupBttn:(UIButton *)sender;
@end
