//
//  UIScrollView+APParallaxHeader.m
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import "UIScrollView+APParallaxHeader.h"

#import <QuartzCore/QuartzCore.h>

@interface APParallaxView ()

@property (nonatomic, readwrite) APParallaxTrackingState state;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic) CGFloat parallaxPortraitHeight;
@property (nonatomic) CGFloat parallaxLandscapeHeight;
@property (nonatomic) CGFloat heightRatio;

@property(nonatomic, assign) BOOL isObserving;

@end



#pragma mark - UIScrollView (APParallaxHeader)
#import <objc/runtime.h>

static char UIScrollViewParallaxView;

@implementation UIScrollView (APParallaxHeader)

- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height {
    [self addParallaxWithImage:image andHeight:height andShadow:YES];
}

- (void)addParallaxWithImage:(UIImage *)image andHeight:(CGFloat)height andShadow:(BOOL)shadow {
    [self addParallaxWithImage:image portraitHeight:height landscapeHeight:height andShadow:shadow];
}

- (void)addParallaxWithImage:(UIImage *)image heightRatio:(CGFloat)heightRatio andShadow:(BOOL)shadow
{
    if(self.parallaxView) {
        if(self.parallaxView.currentSubView) {
            [self.parallaxView.currentSubView removeFromSuperview];
        }
        [self.parallaxView.imageView setImage:image];
    }
    else
    {
        CGFloat heightByRatio = heightRatio * self.bounds.size.width;
        
        APParallaxView *view = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, heightRatio) andShadow:shadow];
        [view setClipsToBounds:YES];
        [view.imageView setImage:image];
        
        view.scrollView = self;
        view.heightRatio = heightRatio;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = heightByRatio;
        self.contentInset = newInset;
        
        self.parallaxView = view;
        self.showsParallax = YES;
    }
}

- (void)addParallaxWithImage:(UIImage *)image portraitHeight:(CGFloat)portraitHeight landscapeHeight:(CGFloat)landscapeHeight andShadow:(BOOL)shadow {
    if(self.parallaxView) {
        if(self.parallaxView.currentSubView) {
            [self.parallaxView.currentSubView removeFromSuperview];
        }
        [self.parallaxView.imageView setImage:image];
    }
    else
    {
        CGFloat heightForCurrentOrientation;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            heightForCurrentOrientation = landscapeHeight;
        } else {
            heightForCurrentOrientation = portraitHeight;
        }
        
        APParallaxView *view = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, heightForCurrentOrientation) andShadow:shadow];
        [view setClipsToBounds:YES];
        [view.imageView setImage:image];
        
        view.scrollView = self;
        view.parallaxLandscapeHeight = landscapeHeight;
        view.parallaxPortraitHeight = portraitHeight;
        view.heightRatio = -1;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = heightForCurrentOrientation;
        self.contentInset = newInset;
        
        self.parallaxView = view;
        self.showsParallax = YES;
    }
}

- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height {
    [self addParallaxWithView:view andHeight:height andShadow:YES];
}

- (void)addParallaxWithView:(UIView*)view andHeight:(CGFloat)height andShadow:(BOOL)shadow {
    [self addParallaxWithView:view portraitHeight:height landscapeHeight:height andShadow:shadow];
}

- (void)addParallaxWithView:(UIView *)view heightRatio:(CGFloat)heightRatio andShadow:(BOOL)shadow {
    if(self.parallaxView) {
        [self.parallaxView.currentSubView removeFromSuperview];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.parallaxView addSubview:view];
    }
    else
    {
        CGFloat heightByRatio = heightRatio * self.bounds.size.width;
        
        APParallaxView *parallaxView = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, heightByRatio) andShadow:YES];
        [parallaxView setClipsToBounds:YES];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [parallaxView addSubview:view];
        
        // bring shadow to foreground
        if (shadow) {
            [parallaxView bringSubviewToFront:parallaxView.shadowView];
        }
        
        parallaxView.scrollView = self;
        parallaxView.heightRatio = heightRatio;
        [self addSubview:parallaxView];
        
        parallaxView.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = heightByRatio;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)addParallaxWithView:(UIView*)view portraitHeight:(CGFloat)portraitHeight landscapeHeight:(CGFloat)landscapeHeight andShadow:(BOOL)shadow {
    if(self.parallaxView) {
        [self.parallaxView.currentSubView removeFromSuperview];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [self.parallaxView addSubview:view];
    }
    else
    {
        CGFloat heightForCurrentOrientation;
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            heightForCurrentOrientation = landscapeHeight;
        } else {
            heightForCurrentOrientation = portraitHeight;
        }
        
        APParallaxView *parallaxView = [[APParallaxView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, heightForCurrentOrientation) andShadow:YES];
        [parallaxView setClipsToBounds:YES];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [parallaxView addSubview:view];
        
        // bring shadow to foreground
        if (shadow) {
            [parallaxView bringSubviewToFront:parallaxView.shadowView];
        }
        
        parallaxView.scrollView = self;
        parallaxView.parallaxLandscapeHeight = landscapeHeight;
        parallaxView.parallaxPortraitHeight = portraitHeight;
        parallaxView.heightRatio = -1;
        [self addSubview:parallaxView];
        
        parallaxView.originalTopInset = self.contentInset.top;
        
        UIEdgeInsets newInset = self.contentInset;
        newInset.top = heightForCurrentOrientation;
        self.contentInset = newInset;
        
        self.parallaxView = parallaxView;
        self.showsParallax = YES;
    }
}

- (void)rotateParallaxViewToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (self.parallaxView) {
        if (self.parallaxView.heightRatio > 0) {
            CGFloat heightByRatio = self.bounds.size.width * self.parallaxView.heightRatio;
            
            CGRect frame = self.parallaxView.frame;
            frame.size.height = heightByRatio;
            self.parallaxView.frame = frame;
            
            UIEdgeInsets newInset = self.contentInset;
            newInset.top = heightByRatio;
            self.contentInset = newInset;
        } else {
            CGFloat heightForCurrentOrientation;
            if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
                heightForCurrentOrientation = self.parallaxView.parallaxLandscapeHeight;
            } else {
                heightForCurrentOrientation = self.parallaxView.parallaxPortraitHeight;
            }
            
            CGRect frame = self.parallaxView.frame;
            frame.size.height = heightForCurrentOrientation;
            self.parallaxView.frame = frame;
            
            UIEdgeInsets newInset = self.contentInset;
            newInset.top = heightForCurrentOrientation;
            self.contentInset = newInset;
        }
    }
}

- (void)setParallaxView:(APParallaxView *)parallaxView {
    objc_setAssociatedObject(self, &UIScrollViewParallaxView,
                             parallaxView,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (APParallaxView *)parallaxView {
    return objc_getAssociatedObject(self, &UIScrollViewParallaxView);
}

- (void)setShowsParallax:(BOOL)showsParallax {
    self.parallaxView.hidden = !showsParallax;
    
    if(!showsParallax) {
        if (self.parallaxView.isObserving) {
            [self removeObserver:self.parallaxView forKeyPath:@"contentOffset"];
            [self removeObserver:self.parallaxView forKeyPath:@"frame"];
            self.parallaxView.isObserving = NO;
        }
    }
    else {
        if (!self.parallaxView.isObserving) {
            [self addObserver:self.parallaxView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.parallaxView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.parallaxView.isObserving = YES;
        }
    }
}

- (BOOL)showsParallax {
    return !self.parallaxView.hidden;
}

@end

#pragma mark - ShadowLayer

@implementation APParallaxShadowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setOpaque:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Gradient Declarations
    NSArray* gradient3Colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
                                (id)[UIColor clearColor].CGColor, nil];
    CGFloat gradient3Locations[] = {0, 1};
    CGGradientRef gradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradient3Colors, gradient3Locations);
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, CGRectGetWidth(rect), 8)];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawLinearGradient(context, gradient3, CGPointMake(0, CGRectGetHeight(rect)), CGPointMake(0, 0), 0);
    CGContextRestoreGState(context);
    
    
    //// Cleanup
    CGGradientRelease(gradient3);
    CGColorSpaceRelease(colorSpace);
    
}

@end

#pragma mark - APParallaxView

@implementation APParallaxView

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame andShadow:YES];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andShadow:(BOOL)shadow {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self setState:APParallaxTrackingActive];
        [self setAutoresizesSubviews:YES];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self.imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageView setClipsToBounds:YES];
        [self addSubview:self.imageView];
        
        if (shadow) {
            self.shadowView = [[APParallaxShadowView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(frame)-8, CGRectGetWidth(frame), 8)];
            [self.shadowView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
            [self addSubview:self.shadowView];
        }
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsParallax) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "APParallaxView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    self.currentSubView = view;
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    // We do not want to track when the parallax view is hidden
    if (contentOffset.y > 0) {
        [self setState:APParallaxTrackingInactive];
    } else {
        [self setState:APParallaxTrackingActive];
    }
    
    if(self.state == APParallaxTrackingActive) {
        CGFloat yOffset = contentOffset.y*-1;
        if ([self.delegate respondsToSelector:@selector(parallaxView:willChangeFrame:)]) {
            [self.delegate parallaxView:self willChangeFrame:self.frame];
        }
        
        [self setFrame:CGRectMake(0, contentOffset.y, CGRectGetWidth(self.frame), yOffset)];
        
        if ([self.delegate respondsToSelector:@selector(parallaxView:didChangeFrame:)]) {
            [self.delegate parallaxView:self didChangeFrame:self.frame];
        }
    }
}

@end
