//
//  TabBarViewController.h
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController
{
    UIButton* button;
}
// Create a view controller and setup it's tab bar item with a title and image
-(UIViewController*) viewController:(UIViewController*)vwController TabTitle:(NSString*) title image:(UIImage*)image;

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

@end
