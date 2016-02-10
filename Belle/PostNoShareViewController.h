//
//  PostNoShareViewController.h
//  Belle
//
//  Created by herocule on 9/17/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostNoShareViewController : UIViewController{
    
    IBOutlet UIImageView *mainImgView;
    
}
@property (strong, nonatomic) UIImage *mainImg;

- (IBAction)click_confirmBttn:(UIButton *)sender;
- (IBAction)click_backBttn:(UIButton *)sender;
- (IBAction)click_cancelBttn:(UIButton *)sender;

@end
