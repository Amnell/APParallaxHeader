//
//  MasterViewController.m
//  APParallaxHeaderDemo
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import "MasterViewController.h"
#import "UIScrollView+APParallaxHeader.h"

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

    [self toggle:nil];
}

- (void)toggle:(id)sender
{
    if(parallaxWithView == NO)
    {
        // add parallax with view
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rover.jpg"]];
        [imageView setFrame:CGRectMake(0, 0, 320, 160)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.tableView addParallaxWithView:imageView andHeight:160];
        parallaxWithView = YES;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with image" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
    else
    {
        // add parallax with image
        [self.tableView addParallaxWithImage:[UIImage imageNamed:@"ParallaxImage.jpg"] andHeight:160];
        parallaxWithView = NO;
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"with view" style:UIBarButtonItemStylePlain target:self action:@selector(toggle:)];
        [self.navigationItem setRightBarButtonItem:barButton];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"Row %i", indexPath.row+1];
    return cell;
}

@end
