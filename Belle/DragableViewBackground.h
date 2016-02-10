//
//  DragableViewBackground.h
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragableView.h"

@interface DragableViewBackground : UIView<DraggableViewDelegate>

//methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(void)cardSwipedSkip:(UIView *)card;
-(void)swipeRight;
-(void)swipeLeft;
-(void)skipCard;
- (void) addFavoriteImg;
-(void)loadCards;
- (UIImage*)reportImage;
@property (retain,nonatomic)NSArray* exampleCardLabels; //%%% the labels the cards
@property (retain,nonatomic)NSMutableArray* allCards; //%%% the labels the cards


@end
