//
//  LooksViewController.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "LooksViewController.h"
#import "SettingViewController.h"
#import "FeedbackDetailViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+Add.h"
#import "UIKit+AFNetworking.h"
@interface LooksViewController ()

@end

@implementation LooksViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"LOOKS" image:[UIImage imageNamed:@"look_tabbar"] selectedImage:[UIImage imageNamed:@"look_tabbar"]];
        
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"LOOKS";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goSetting)];
    selectOption = @"0";
    [looksCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self getLooks];
}
- (void)goSetting{
    SettingViewController *sub = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:sub animated:YES];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return selectLookArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
        cell.backgroundColor=[UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
        NSLog(@"%f,%f",cell.frame.size.width, cell.frame.size.height);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,cell.frame.size.width, cell.frame.size.height)];
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imgView.layer.shouldRasterize = YES;
        imgView.clipsToBounds = YES;
        
        [imgView setImageWithURL:[NSURL URLWithString:selectLookArray[indexPath.row][@"url"]] placeholderImage:[UIImage imageNamed:@"default_image"] ];
        imgView.tag = 100+indexPath.row;
        [cell.contentView addSubview:imgView];
    
    
    
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width/3-4, [[UIScreen mainScreen] bounds].size.width/3-4);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FeedbackDetailViewController *sub = [[FeedbackDetailViewController alloc] init];
    sub.lookDetailDic = [[NSDictionary alloc] initWithDictionary:selectLookArray[indexPath.row]];
    [self.navigationController pushViewController:sub animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click_selectOptionBttn:(UIButton *)sender {
    
    if(sender.tag == 101){
        [friendBttn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;
        [worldBttn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            indctView.center = CGPointMake(friendBttn.center.x, friendBttn.frame.size.height-1);
        }];
        selectLookArray = [[NSArray  alloc] initWithArray:FvLookArray];
        selectOption = @"0";
    }
    else{
        [worldBttn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal] ;
        [friendBttn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.4 animations:^{
            indctView.center = CGPointMake(worldBttn.center.x, worldBttn.frame.size.height-1);
        }];
        selectLookArray = [[NSArray  alloc] initWithArray:TrdLookArray];
        selectOption = @"1";
    }
  //  [looksCollectionView reloadData];
    [UIView transitionWithView:looksCollectionView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        [looksCollectionView reloadData];
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
    
}
- (void)getLooks{
    /*Action = looks
     o Mandatory field
     ent_sess_token
     ent_dev_id*/
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    
    NSLog(@"looks Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/looks" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"looks JSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            FvLookArray = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"favorites"]];
            TrdLookArray = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"trendings"]];
            if ([selectOption  isEqual: @"0"])selectLookArray = [[NSArray  alloc] initWithArray:FvLookArray];
            else selectLookArray = [[NSArray  alloc] initWithArray:TrdLookArray];
            [UIView transitionWithView:looksCollectionView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                BOOL oldState = [UIView areAnimationsEnabled];
                                [UIView setAnimationsEnabled:NO];
                                [looksCollectionView reloadData];
                                [UIView setAnimationsEnabled:oldState];
                            }
                            completion:nil];
        }
        else{
            
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

}
@end
