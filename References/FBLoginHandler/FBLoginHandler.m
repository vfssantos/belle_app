//
//  FBLoginHandler.m
//  FBShareSample
//
//  Created by Surender Rathore on 17/12/13.
//  Copyright (c) 2013 Facebook Inc. All rights reserved.
//

#import "FBLoginHandler.h"
#import "MBProgressHUD.h"
@interface FBLoginHandler ()

@property (strong, nonatomic) NSArray *readPermission;
@property (strong, nonatomic) NSArray *publishPermission;
@property (assign, nonatomic) BOOL isLoggedIn;
@end

@implementation FBLoginHandler
@synthesize delegate;
@synthesize isLoggedIn;
static FBLoginHandler *fbLoginHandler;

+ (id)sharedInstance {
	if (!fbLoginHandler) {
		fbLoginHandler  = [[self alloc] init];
	}
	
	return fbLoginHandler;
}


-(id)init {
    self = [super init];
    if (self) {
        _readPermission = @[@"public_profile",@"email",@"user_friends"];
        _publishPermission = @[@"publish_actions"];
        
      
    }
    return self;
}

-(void)loginWithFacebook {
    
    
    [FBSession openActiveSessionWithReadPermissions:_readPermission
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         [self sessionStateChanged:session state:state error:error];
     }];
    

}
-(void)requestForNewPermission:(NSArray*)permission{
    
    [[FBSession activeSession] requestNewReadPermissions:permission
                                       completionHandler:^(FBSession *session , NSError *error){
        
    }];
}
-(void)logoutFacebookUser {
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        isLoggedIn = NO;
        
        // Close the session and remove the access token from the cache
        // The session state handler (in self) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
       
    }
}

/*
 Call this mehtod in AppDelegate application:didFinishLaunchingWithOptions:
 */
-(void)updateFacebookSessionwithblock:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        BOOL status = [FBSession openActiveSessionWithAllowLoginUI:YES];
        completionBlock(status,nil);
       
        // If there's no cached session, we will show a login button
    } else {
        
         NSLog(@"Cached session not found");
        completionBlock(NO,nil);
       
    }
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self fetchLoggedInUserInfo];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self logout];
  //      [delegate didFacebookUserLoginFail];
        
        return;
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}



- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

-(void)fetchLoggedInUserInfo {
    
    [FBRequestConnection
     startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                       id<FBGraphUser> user,
                                       NSError *error) {
         [MBProgressHUD hideHUDForView:self animated:YES];
         if (!error) {
             
             isLoggedIn = YES;
             
             NSMutableDictionary *mDictionary = [[NSMutableDictionary alloc] init];
             [mDictionary setValue:user.first_name forKey:@"FirstName"];
             [mDictionary setValue:user.last_name forKey:@"LastName"];
             [mDictionary setValue:user.name forKey:@"Name"];
             [mDictionary setValue:user.objectID forKey:@"FacebookId"];
             [mDictionary setValue:user[@"gender"] forKey:@"Gender"];
             if (user[@"email"]) {
                [mDictionary setValue:user[@"email"] forKey:@"Email"];
             }
             
             if (delegate && [delegate respondsToSelector:@selector(didFacebookUserLogin:withDetail:)]) {
                 [delegate didFacebookUserLogin:isLoggedIn withDetail:mDictionary];
             }
         }
         else {
             NSLog(@"facebook error : %@",[error localizedDescription]);
             
             isLoggedIn = NO;
             if (delegate && [delegate respondsToSelector:@selector(didFacebookUserLogin:withDetail:)]) {
                 [delegate didFacebookUserLogin:isLoggedIn withDetail:Nil];
             }
         }
     }];
}

-(void)logout {
    
    if (delegate && [delegate respondsToSelector:@selector(didFacebookUserLogout:)]) {
        [delegate didFacebookUserLogout:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
