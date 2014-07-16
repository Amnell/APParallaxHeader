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

@interface MasterViewController ()
{
    BOOL parallaxWithView;
}
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
    [self.navigationItem setRightBarButtonItem:barButton];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(200, 200)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self toggle:nil];
}

- (void)toggle:(id)sender
{
    if(parallaxWithView == NO)
    {
        // add parallax with view
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rover.jpg"]];
        [imageView setFrame:CGRectMake(0, 0, 320, PARALLAX_HEIGHT)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.tableView addParallaxWithView:imageView andHeight:PARALLAX_HEIGHT];
        parallaxWithView = YES;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    else
    {
        // add parallax with image
        [self.tableView addParallaxWithImage:[UIImage imageNamed:@"ParallaxImage.jpg"] andHeight:PARALLAX_HEIGHT];
        parallaxWithView = NO;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"Row %li", indexPath.row+1];
    return cell;
}

@end
