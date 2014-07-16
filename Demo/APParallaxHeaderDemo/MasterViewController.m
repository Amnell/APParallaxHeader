//
//  MasterViewController.m
//  APParallaxHeaderDemo
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import "MasterViewController.h"
#import "UIScrollView+APParallaxHeader.h"

#define PARALLAX_HEIGHT 320

@interface MasterViewController () <APParallaxViewDelegate> {
    BOOL parallaxWithView;
}
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(200, 200)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self toggle:nil];
}

- (void)toggle:(id)sender {
    /**
     *  For demo purposes this view controller either adds a parallaxView with a custom view
     *  or a parallaxView with an image.
     */
    if(parallaxWithView == NO) {
        // add parallax with view
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rover.jpg"]];
        [imageView setFrame:CGRectMake(0, 0, 320, PARALLAX_HEIGHT)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.tableView addParallaxWithView:imageView andHeight:PARALLAX_HEIGHT];
        parallaxWithView = YES;
        
        // Update the toggle button
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    else {
        // add parallax with image
        [self.tableView addParallaxWithImage:[UIImage imageNamed:@"ParallaxImage.jpg"] andHeight:PARALLAX_HEIGHT];
        parallaxWithView = NO;
        
        // Update the toggle button
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    
    /**
     *  Setting a delegate for the parallaxView will allow you to get callbacks for when the
     *  frame of the parallaxView changes.
     *  Totally optional thou.
     */
    self.tableView.parallaxView.delegate = self;
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"Row %li", indexPath.row+1];
    return cell;
}

#pragma mark - APParallaxViewDelegate

- (void)parallaxView:(APParallaxView *)view willChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview before its frame changes
    NSLog(@"parallaxView:willChangeFrame: %@", NSStringFromCGRect(frame));
}

- (void)parallaxView:(APParallaxView *)view didChangeFrame:(CGRect)frame {
    // Do whatever you need to do to the parallaxView or your subview after its frame changed
    NSLog(@"parallaxView:didChangeFrame: %@", NSStringFromCGRect(frame));
}

@end
