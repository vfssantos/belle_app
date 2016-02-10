//
//  OverlayView.h
//  Belle
//
//  Created by herocule on 5/19/15.
//  Copyright (c) 2015 herocule. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger , GGOverlayViewMode) {
    GGOverlayViewModeLeft,
    GGOverlayViewModeRight
};

@interface OverlayView : UIView
@property (nonatomic) GGOverlayViewMode mode;
@property (nonatomic, strong) UIImageView *imageView;
@end
