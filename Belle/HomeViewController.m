//
//  HomeViewController.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingViewController.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"RUNWAY" image:[UIImage imageNamed:@"home_tabbar"] selectedImage:[UIImage imageNamed:@"home_tabbar"]];
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"RUNWAY";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(goSetting)];
    
    
    CGRect frmBtn = buttonContentView.frame;
    frmBtn.size.width = [UIScreen mainScreen].bounds.size.width;
    
    CGRect frmSpacer1=spacerView1.frame;
    frmSpacer1.origin.x=0;
    frmSpacer1.origin.y=0;
    frmSpacer1.size.height=([UIScreen mainScreen].bounds.size.height-frmBtn.size.height-[UIScreen mainScreen].bounds.size.width*0.8)/3;
    frmSpacer1.size.width=([UIScreen mainScreen].bounds.size.height);
    
    CGRect frmCard = cardContentView.frame;
    frmCard.origin.x=([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width*0.8)/2;
    frmCard.origin.y=frmSpacer1.size.height+8;
    frmCard.size.height=[UIScreen mainScreen].bounds.size.width*0.8;
    frmCard.size.width=[UIScreen mainScreen].bounds.size.width*0.8;
    
    CGRect frmSpacer2=spacerView2.frame;
    frmSpacer2.origin.x=0;
    frmSpacer2.origin.y=frmSpacer1.size.height+frmCard.size.height;
    frmSpacer2.size.height=frmSpacer1.size.height;
    frmSpacer2.size.width=([UIScreen mainScreen].bounds.size.height);
    
    //Button Height - it depends on the Spacer Height and that's why it is down here
    frmBtn.origin.y=frmSpacer1.size.height*2+frmCard.size.height+8;
    
    CGRect frmSpacer3=spacerView3.frame;
    frmSpacer3.origin.x=0;
    frmSpacer3.origin.y=frmSpacer1.size.height+frmCard.size.height+frmSpacer2.size.height+frmBtn.size.height;
    frmSpacer3.size.height=frmSpacer1.size.height;
    frmSpacer3.size.width=([UIScreen mainScreen].bounds.size.height);
    
    //Set Frames
    buttonContentView.frame = frmBtn;
    spacerView1.frame=frmSpacer1;
    spacerView2.frame=frmSpacer2;
    spacerView3.frame=frmSpacer3;
    cardContentView.frame=frmCard;
    
    [swipeContentView setHidden:YES];
    [self getLookImg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CardAllSwiped:) name:@"CardAllSwiped" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
}
- (void)setSkipBttn{
    skipBttn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 28)];
    [skipBttn setTitleColor:[UIColor colorWithRed:99/255.0f green:159/255.0f blue:213/255.0f alpha:1.0f] forState:UIControlStateNormal];
    skipBttn.titleLabel.font = [UIFont fontWithName:@"KohinoorDevanagari-Medium" size:14];
    [skipBttn setTitle:@"Skip" forState:UIControlStateNormal];
    [skipBttn setBackgroundColor:[UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:0.8f]];
    [skipBttn addTarget:self action:@selector(skipCard) forControlEvents:UIControlEventTouchUpInside];
    skipBttn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, cardContentView.frame.size.height+cardContentView.frame.origin.y -28);
    skipBttn.layer.cornerRadius = 6;
    skipBttn.layer.masksToBounds = YES;
    skipBttn.clipsToBounds = YES;
    skipBttn.layer.borderColor =  [UIColor whiteColor].CGColor;
    skipBttn.layer.borderWidth = 1.0f;
    skipBttn.userInteractionEnabled = YES;
    
    [swipeContentView addSubview:skipBttn];
}
- (void)goSetting{
    SettingViewController *sub = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:sub animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)CardAllSwiped:(NSNotification*)note //键盘出现
{
    [UIView transitionWithView:self.view
                      duration:0.8
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                       
                        [swipeContentView setHidden:YES];
                        [self getLookImg];

                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
    
}
-(void)skipCard{
    [draggableBackground skipCard];
}
- (IBAction)click_likeBttn:(UIButton *)sender {
    [draggableBackground swipeLeft];
}

- (IBAction)click_dislikeBttn:(id)sender {
    [draggableBackground swipeRight];
}

- (IBAction)click_favoriteBttn:(UIButton *)sender {
    [draggableBackground addFavoriteImg];
}

- (IBAction)reportBttn:(UIButton *)sender {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Report image"];
    controller.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImage *tmpImg = [draggableBackground reportImage];
    NSData *data = UIImageJPEGRepresentation(tmpImg,1);
    [controller addAttachmentData:data  mimeType:@"image/jpeg" fileName:@"Photograph.jpg"];
    
    [controller setToRecipients:[NSArray arrayWithObjects:@"contato@belleapp.com.br",nil]];
    [self presentViewController:controller animated:YES completion:NULL];

}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *mssg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            mssg = @"Email Cancelled";
            break;
        case MFMailComposeResultSaved:
            mssg = @"Email Saved";
            break;
        case MFMailComposeResultSent:
            mssg = @"Email Sent";
            break;
        case MFMailComposeResultFailed:
            mssg = @"Email Failed";
            break;
        default:
            mssg = @"Email Not Sent";
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)click_tryAgainBttn:(UIButton *)sender {
    [swipeContentView setHidden:YES];
    [self getLookImg];
}
- (void)getLookImg{
    /*Action = findPhoto
     o Mandatory field
     ent_sess_token
     ent_dev_id*/
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeClear];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    
    NSLog(@"findPhoto Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/findPhoto" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"findPhoto JSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            
            [draggableBackground removeFromSuperview];
            draggableBackground = [[DragableViewBackground alloc]initWithFrame:CGRectMake(0, 0, cardContentView.frame.size.width, cardContentView.frame.size.height)];
            [cardContentView addSubview:draggableBackground];
            
            
            draggableBackground.exampleCardLabels = [[NSArray alloc] initWithArray:[responseObject objectForKey:@"photos"]];
            [draggableBackground loadCards];
            [emptyBgView removeFromSuperview];
            [self setSkipBttn];
            [UIView transitionWithView:swipeContentView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                BOOL oldState = [UIView areAnimationsEnabled];
                                [UIView setAnimationsEnabled:NO];
                                [swipeContentView setHidden:NO];
                                [UIView setAnimationsEnabled:oldState];
                            }
                            completion:nil];

        }
        else{
            [self.view addSubview:emptyBgView];
            emptyBgView.center = CGPointMake(self.navigationController.view.center.x, 200);
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [SVProgressHUD dismiss];
    }];

    
    
}


@end
