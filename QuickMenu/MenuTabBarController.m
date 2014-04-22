//
//  MenuTabBarController.m
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MenuTabBarController.h"

@implementation MenuTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    UIBarButtonItem *comment = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                target:self
                                action:nil];
    
    self.navigationItem.rightBarButtonItem = comment;
}

@end
