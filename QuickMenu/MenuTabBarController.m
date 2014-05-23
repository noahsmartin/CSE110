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

@end
