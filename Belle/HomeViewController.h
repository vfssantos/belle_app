//
//  HomeViewController.h
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragableViewBackground.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface HomeViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    UIButton *skipBttn;
    
    IBOutlet UIView *emptyBgView;
    
    IBOutlet UIView *buttonContentView;
    IBOutlet UIView *swipeContentView;
    IBOutlet UIView *cardContentView;
    IBOutlet UIView *spacerView1;
    IBOutlet UIView *spacerView2;
    IBOutlet UIView *spacerView3;
    DragableViewBackground *draggableBackground;
}

- (IBAction)click_likeBttn:(UIButton *)sender;
- (IBAction)click_dislikeBttn:(id)sender;
- (IBAction)click_favoriteBttn:(UIButton *)sender;
- (IBAction)reportBttn:(UIButton *)sender;
- (IBAction)click_tryAgainBttn:(UIButton *)sender;


@end
