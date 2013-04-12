//
//  DetailViewController.h
//  APParallaxHeaderDemo
//
//  Created by Mathias Amnell on 2013-04-12.
//  Copyright (c) 2013 Apping AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
