//
//  UIScrollView+APParallaxHeader.h
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APParallaxView;
@class APParallaxShadowView;

#pragma mark UIScrollView Category

@interface UIScrollView (APParallaxHeader)

/**
 *  Adds a parallax with an image, an initial height and a bottom inner shadow.
 *
 *  @param image  An UIImage to parallax when scrolling.
 *  @param height The max height for the parallax header
 *  @param shadow BOOL to show or hide the bottom inner shadow.
 */
- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height andShadow:(BOOL)shadow;

/**
 *  Adds a parallax with an image and an initial height.
 *
 *  @param image  An UIImage to parallax when scrolling.
 *  @param height The max height for the parallax header.
 */
- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height;

/**
 *  Adds a parallax with a custom view with a given initial height.
 *
 *  @param view   A UIView to display in the parallax header.
 *  @param height The max height for the parallax header.
 */
- (void)addParallaxWithView:(UIView *)view andHeight:(CGFloat)height;

- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height andShadow:(BOOL)shadow;


/**
 *  Getter for the parallaxView
 */
@property (nonatomic, strong, readonly) APParallaxView *parallaxView;

@property (nonatomic, assign) BOOL showsParallax;

@end

#pragma mark APParallaxView

@protocol APParallaxViewDelegate;

typedef NS_ENUM(NSUInteger, APParallaxTrackingState) {
    APParallaxTrackingActive = 0,
    APParallaxTrackingInactive
};

@interface APParallaxView : UIView

@property (weak) id<APParallaxViewDelegate> delegate;

@property (nonatomic, readonly) APParallaxTrackingState state;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) APParallaxShadowView *shadowView;
@property (nonatomic, strong) UIView *customView;

- (id)initWithFrame:(CGRect)frame andShadow:(BOOL)shadow;

@end

/**
 *  The APParallaxView delegate will allow you to get information for when the
 *  parallax header view will change its frame, so that you can do your repositioning etc.
 */
@protocol APParallaxViewDelegate <NSObject>
@optional
/**
 *  Delegate call for when the APParallaxView will change its frame.
 *
 *  @param view  The APParallaxView that will change its frame.
 *  @param frame The target frame.
 */
- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame;

/**
 *  Delegate call for when the APParallaxView did change its frame.
 *
 *  @param view  The APParallaxView that changed its frame.
 *  @param frame The target frame.
 */
- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame;
@end

#pragma mark APParallaxShadowView

@interface APParallaxShadowView : UIView

@end
