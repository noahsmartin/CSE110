//
//  MenuTabBarController.m
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MenuTabBarController.h"
#import "MyMenuViewController.h"

@implementation MenuTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showMyMenuSegue"])
    {
        MyMenuViewController* newController = ((MyMenuViewController*) segue.destinationViewController);
        newController.myMenu = self.menu;
    }
}

@end
