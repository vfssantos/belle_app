//
//  AppDelegate.m
//  Belle
//
//  Created by herocule on 5/18/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//
#define thumb_color [UIColor colorWithRed:99/255.0f green:159/255.0f blue:213/255.0f alpha:1.0f]

#import "AppDelegate.h"
#import "SplashViewController.h"
#import "SignInViewController.h"
#import "FBLoginHandler.h"

#import "HomeViewController.h"
#import "CameraViewController.h"
#import "FeedbackViewController.h"
#import "LooksViewController.h"
#import "BaseTabBarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    FBLoginHandler *fbHandler = [[FBLoginHandler alloc] init];
    [fbHandler updateFacebookSessionwithblock:^(BOOL successed , NSError *error)
     {
     }];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"KohinoorDevanagari-Medium" size:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:thumb_color];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    SplashViewController *sub = [[SplashViewController alloc] init];
    self.window.rootViewController = sub;
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeSplash) userInfo:nil repeats:NO];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)removeSplash
{
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SignInViewController *sub = [[SignInViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sub];
    [UIView transitionWithView:self.window
                      duration:0.8
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                         if([[[NSUserDefaults standardUserDefaults] objectForKey:@"belle_loginFlg"]  isEqual: @"yes"])
                         {
                             [self gotoMainPage];
                         }
                         else{
                             self.window.rootViewController = nav;
                             
                             self.window.backgroundColor = [UIColor whiteColor];
                             [self.window makeKeyAndVisible];
                         }
                       [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];
    
    
    
}
- (void) gotoMainPage{
    HomeViewController *homeView = [[HomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    CameraViewController *searchView = [[CameraViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:searchView];
    
    FeedbackViewController *notificationView = [[FeedbackViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:notificationView];
    
    LooksViewController *profileView = [[LooksViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:profileView];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"KohinoorDevanagari-Medium" size:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setBarTintColor:thumb_color];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  nav1,
                                  nav2,
                                  nav3,
                                  nav4,nil];
    BaseTabBarViewController *sub = [[BaseTabBarViewController alloc] init];
    [sub setViewControllers:myViewControllers];
    
    self.window.rootViewController = sub;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
