//
//  OverlayView.m
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noButton"]];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
    }
    return self;
}

-(void)setMode:(GGOverlayViewMode)mode
{
   
    
    _mode = mode;
    
    if(mode == GGOverlayViewModeLeft) {
        imageView.image = [UIImage imageNamed:@"tint_dislike"];
        imageView.frame = CGRectMake(self.frame.size.width - 100, 20, 80, 80);
    } else {
        imageView.image = [UIImage imageNamed:@"tint_like"];
        imageView.frame = CGRectMake(20, 20, 80, 80);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    imageView.frame = CGRectMake(50, 50, 100, 100);
}

@end
