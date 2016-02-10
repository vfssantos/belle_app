//
//  CameraViewController.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"CAMERA" image:[UIImage imageNamed:@"camera_tabbar"] selectedImage:[UIImage imageNamed:@"camera_tabbar"]];
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
