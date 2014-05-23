//
//  MenuTabBarController.m
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MenuTabBarController.h"
#import "MyMenuViewController.h"
#import "MenyouApi.h"
#import "Categories.h"
#import "CategoryViewController.h"
#import "WYPopoverController.h"

@interface MenuTabBarController() <WYPopoverControllerDelegate>
@property WYPopoverController* popover;
@end

@implementation MenuTabBarController

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"showMyMenuSegue"])
    {
        if(!([self.restaurant.menu numberSelected] > 0))
        {
        
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle:@"No dishes in your order" message:@"You haven't added anything to your order!" delegate:self cancelButtonTitle:@"Add food!" otherButtonTitles:@"Feeling Lucky?", nil];
            
            [errorAlert show];
            return NO;
        }
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"showMyMenuSegue"])
    {
        MyMenuViewController* newController = ((MyMenuViewController*) segue.destinationViewController);
        newController.restaurant = self.restaurant;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        // back to the menu
    }
    else{
        // pick random set of menu items
        [self.restaurant.menu pickRandomItems];
        [self performSegueWithIdentifier:@"showMyMenuSegue" sender:self];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.popover = [[WYPopoverController alloc] initWithContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"popover"]];
    [self.popover setPopoverContentSize:CGSizeMake(150, 240)];    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"My Order" style:UIBarButtonItemStylePlain target:self action:@selector(myorderpressed:)];
    [button setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14] } forState:UIControlStateNormal];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:@"..." style:UIBarButtonItemStylePlain target:self action:@selector(showpopover:event:)];
    [button2 setTitleTextAttributes:@{ NSFontAttributeName: [UIFont fontWithName:@"Helvetica Bold" size:14] } forState:UIControlStateNormal];
    [[self navigationItem] setRightBarButtonItems:[NSArray arrayWithObjects:button, button2, nil]];
}

-(void)myorderpressed:(id)sender
{
    if([self shouldPerformSegueWithIdentifier:@"showMyMenuSegue" sender:sender])
        [self performSegueWithIdentifier:@"showMyMenuSegue" sender:sender];
}

-(void)showpopover:(UIBarButtonItem*)sender event:(UIEvent*)event;
{
    [self.popover presentPopoverFromRect:[[event.allTouches anyObject] view].bounds inView:[[event.allTouches anyObject] view] permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    
}

@end
