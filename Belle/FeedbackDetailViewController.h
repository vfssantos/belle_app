//
//  FeedbackDetailViewController.h
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackDetailViewController : UIViewController
{
    
    IBOutlet UILabel *likeLbl;
    IBOutlet UILabel *dislikeLbl;
    IBOutlet UILabel *wldVwLbl;
    IBOutlet UILabel *fvrtLbl;
    IBOutlet UIView *feedbackView;
    IBOutlet UIView *spacerView1;
    IBOutlet UIView *spacerView2;
    IBOutlet UIView *spacerView3;
    IBOutlet UIImageView *mainImgView;
}
@property (strong, nonatomic) NSDictionary *lookDetailDic;
@property (strong, nonatomic) NSString *mineStr;
@end
