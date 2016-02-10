//
//  LooksViewController.h
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LooksViewController : UIViewController
{
    NSArray *FvLookArray, *TrdLookArray, *selectLookArray;
    NSString *selectOption;
    
    IBOutlet UIView *selectOptionContentView;
    IBOutlet UIButton *friendBttn;
    IBOutlet UIButton *worldBttn;
    IBOutlet UILabel *indctView;
    
    IBOutlet UICollectionView *looksCollectionView;
}
- (IBAction)click_selectOptionBttn:(UIButton *)sender;
@end
