//
//  DragableView.h
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;
-(void)cardSwipedSkip:(UIView *)card;
@end

@interface DragableView : UIView
@property (weak) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;
@property (nonatomic,strong)NSString *imgStr; //%%% a placeholder for any card-specific information
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)NSString *fvImgFlg;
@property (nonatomic,strong)NSString *ptID;


@property (nonatomic,strong)UIImageView *fvImgview;

-(void)swipeClickAction;
-(void)leftClickAction;
-(void)rightClickAction;
@end
