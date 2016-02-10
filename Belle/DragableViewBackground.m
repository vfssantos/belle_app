//
//  DragableViewBackground.m
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "DragableViewBackground.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

@implementation DragableViewBackground{
    NSInteger cardsLoadedIndex; //%%% the index of the card you have loaded into the loadedCards array last
    NSMutableArray *loadedCards; //%%% the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    
    UIButton* menuButton;
    UIButton* messageButton;
    UIButton* checkButton;
    UIButton* xButton;
}

static const int MAX_BUFFER_SIZE = 2; //%%% max number of cards loaded at any given time, must be greater than 1

@synthesize exampleCardLabels; //%%% all the labels I'm using as example data at the moment
@synthesize allCards;//%%% all the cards
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        
        loadedCards = [[NSMutableArray alloc] init];
        allCards = [[NSMutableArray alloc] init];
        cardsLoadedIndex = 0;
//        [self loadCards];
    }
    return self;
}


-(DragableView *)createDraggableViewWithDataAtIndex:(NSInteger)index
{
    DragableView *draggableView = [[DragableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [draggableView.imgView setImageWithURL:[NSURL URLWithString:[exampleCardLabels objectAtIndex:index][@"url"]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    
    draggableView.ptID = [exampleCardLabels objectAtIndex:index][@"pid"];
    draggableView.fvImgFlg = @"2";
    draggableView.delegate = self;
    return draggableView;
}

//%%% loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards
{
    if([exampleCardLabels count] > 0) {
        NSInteger numLoadedCardsCap =(([exampleCardLabels count] > MAX_BUFFER_SIZE)?MAX_BUFFER_SIZE:[exampleCardLabels count]);
        //%%% if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
        
        //%%% loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "exampleCardLabels" with your own array of data
        for (int i = 0; i<[exampleCardLabels count]; i++) {
            DragableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            
            UITapGestureRecognizer *tapGst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addFavoriteImg)];
            tapGst.numberOfTapsRequired = 2;
            [newCard addGestureRecognizer:tapGst];
            
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                //%%% adds a small number of cards to be loaded
                [loadedCards addObject:newCard];
            }
        }
        
        //%%% displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i] belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; //%%% we loaded a card into loaded cards, so we have to increment
        }
    }
}


- (void) addFavoriteImg{
    DragableView *dragView = [loadedCards firstObject];
    [UIView transitionWithView:dragView.fvImgview
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        if([dragView.fvImgFlg  isEqual: @"2"]){
                            dragView.fvImgview.image = [UIImage imageNamed:@"indict_favorite.png"];
                            dragView.fvImgFlg = @"1";
                        }
                        else{
                            dragView.fvImgview.image = [UIImage imageNamed:@"indict_"];
                            dragView.fvImgFlg = @"2";
                        }
                        [self favorite:dragView.ptID type:dragView.fvImgFlg];
                        
                        
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:nil];

    
    
}
- (UIImage*)reportImage{
    DragableView *dragView = [loadedCards firstObject];
    
    return dragView.imgView.image;
}
-(void)cardSwipedLeft:(UIView *)card;
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    DragableView *dragView = [loadedCards firstObject];
    [self likeAction:dragView.ptID type:@"2"];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    if(loadedCards.count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CardAllSwiped" object:self userInfo:nil];
    }
}

-(void)cardSwipedRight:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    DragableView *dragView = [loadedCards firstObject];
    [self likeAction:dragView.ptID type:@"1"];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    if(loadedCards.count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CardAllSwiped" object:self userInfo:nil];
    }

}
-(void)cardSwipedSkip:(UIView *)card
{
    //do whatever you want with the card that was swiped
    //    DraggableView *c = (DraggableView *)card;
    DragableView *dragView = [loadedCards firstObject];
    [self likeAction:dragView.ptID type:@"3"];
    [loadedCards removeObjectAtIndex:0]; //%%% card was swiped, so it's no longer a "loaded card"
    
    if (cardsLoadedIndex < [allCards count]) { //%%% if we haven't reached the end of all cards, put another into the loaded cards
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++;//%%% loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)] belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    if(loadedCards.count == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CardAllSwiped" object:self userInfo:nil];
    }
    
}

//%%% when you hit the right button, this is called and substitutes the swipe
-(void)swipeRight
{
    DragableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
    
}
-(void)skipCard{
    DragableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    
    [dragView swipeClickAction];
    
}
//%%% when you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft
{
    DragableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
    
}
- (void)likeAction:(NSString*)ptID type:(NSString*)nType{
    /*Action = likeAction
     o Mandatory field
     ent_sess_token
     ent_dev_id
     photo_id
     photo_action (1 - like, 2 - dislike, 3 - skip)*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"photo_id":ptID,
                                 @"photo_action":nType};
    
    NSLog(@"likeAction Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/likeAction" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"likeAction JSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
   
}
- (void)favorite:(NSString*)ptID type:(NSString*)nType{
    /*Action = favoriteAction
     o Mandatory field
     ent_sess_token
     ent_dev_id
     photo_id
     photo_action (1 - add to favorite, 2 - delete from favorite)*/
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"ent_sess_token":[defaults objectForKey:@"belle_token"],
                                 @"ent_dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                 @"photo_id":ptID,
                                 @"photo_action":nType};
    
    NSLog(@"favoriteAction Parameters = %@",parameters);
    [manager POST:@"http://159.203.235.29/service.php/MyApi/favoriteAction" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"favoriteAction JSON: %@", responseObject);
        if([[responseObject objectForKey:@"errFlag"]  isEqual: @"1"])
        {
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];

    
}
@end
