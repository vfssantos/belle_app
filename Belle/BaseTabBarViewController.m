//
//  BaseTabBarViewController.m
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"camera.png"] highlightImage:[UIImage imageNamed:@"camera_selected.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
