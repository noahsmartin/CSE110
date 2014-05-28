//
//  SettingsViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/10/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "SettingsViewController.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenyouApi.h"

@interface SettingsViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property MEDynamicTransition* dynamicTransition;
@property (weak, nonatomic) IBOutlet UILabel *usernameView;
@property (weak, nonatomic) IBOutlet UISwitch *vegetarian;
@property (weak, nonatomic) IBOutlet UISwitch *vegan;
@property (weak, nonatomic) IBOutlet UISwitch *dairy;
@property (weak, nonatomic) IBOutlet UISwitch *peanuts;
@property (weak, nonatomic) IBOutlet UISwitch *kosher;
@property (weak, nonatomic) IBOutlet UISwitch *lowfat;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dynamicTransition = [[MEDynamicTransition alloc] init];
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.delegate = self.dynamicTransition;
    
    self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.slidingViewController.delegate action:@selector(handlePanGesture:)];
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    NSString* temp = @"Logged in as: ";
    NSString* username = [MenyouApi getInstance].username;
    if(username)
        self.usernameView.text = [temp stringByAppendingString:username];
    
    for(int i = 0; i < [[MenyouApi getInstance].preferences count]; i++)
    {
        NSString* state = [[MenyouApi getInstance].preferences objectAtIndex:i];
        if([state isEqualToString:@"1"])
        {
            if(i == 0)
                [_vegetarian setOn:YES animated:YES];
            else if(i == 1)
                [_vegan setOn:YES animated:YES];
            else if(i == 2)
                [_dairy setOn:YES animated:YES];
            else if(i == 3)
                [_peanuts setOn:YES animated:YES];
            else if(i == 4)
                [_kosher setOn:YES animated:YES];
            else if(i == 5)
                [_lowfat setOn:YES animated:YES];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
}

- (IBAction)vegetarian:(id)sender
{
    [self togglePref:@"vegetarian" Value:0];
}

- (IBAction)vegan:(id)sender
{
    [self togglePref:@"vegan" Value:1];
}

- (IBAction)diary:(id)sender
{
    [self togglePref:@"dairyfree" Value:2];
}

- (IBAction)peanuts:(id)sender
{
    [self togglePref:@"peanutallergy" Value:3];
}

- (IBAction)kosher:(id)sender
{
    [self togglePref:@"kosher" Value:4];
}

- (IBAction)lowfat:(id)sender
{
    [self togglePref:@"lowfat" Value:5];
}

- (IBAction)logout:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Logged out" message:@"Logged out successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [[MenyouApi getInstance] logout];
    ECSlidingViewController *slidingController = self.slidingViewController;
    
    [slidingController anchorTopViewToRightAnimated:YES];
    slidingController.topViewController = self.homeViewController;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
}

-(void)togglePref:(NSString*)field Value:(int)value
{
    //Value indicates which setting it is...vegetarian = 0, vegan = 1, dairy = 2, peanuts = 3, kosher = 4, lowfat = 5
    if([[[MenyouApi getInstance].preferences objectAtIndex:value] isEqualToString:@"0"]/*array[0] == 0*/)
    {
        //if its off
        [[MenyouApi getInstance] setPref:field withValue:1 withBlock:^(BOOL success) {
            if(success)
            {
                [[MenyouApi getInstance].preferences replaceObjectAtIndex:value withObject:@"1"];
                [[MenyouApi getInstance] saveArray];
                //set the array of pref, on
            }
        }];
    }
    else
    {
        //if its on
        [[MenyouApi getInstance] setPref:field withValue:0 withBlock:^(BOOL success) {
            if(success)
            {
                [[MenyouApi getInstance].preferences replaceObjectAtIndex:value withObject:@"0"];
                [[MenyouApi getInstance] saveArray];
                //set the array of pref, off
            }
        }];
    }
}

@end
