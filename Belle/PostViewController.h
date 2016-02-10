//
//  PostViewController.h
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostViewController : UIViewController
{
    NSString *optionStr;
    IBOutlet UIImageView *mainImgView;
    
    IBOutlet UIImageView *optionFrdImgView;
    IBOutlet UIImageView *optionWrdImgView;
}
@property (strong, nonatomic) UIImage *mainImg;
- (IBAction)click_optionBttn:(UIButton *)sender;
- (IBAction)click_confirmBttn:(UIButton *)sender;
- (IBAction)click_backBttn:(UIButton *)sender;
- (IBAction)click_cancelBttn:(UIButton *)sender;
@end
