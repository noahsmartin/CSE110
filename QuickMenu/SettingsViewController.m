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
                [_vegetarian setOn:YES animated:NO];
            else if(i == 1)
                [_vegan setOn:YES animated:NO];
            else if(i == 2)
                [_dairy setOn:YES animated:NO];
            else if(i == 3)
                [_peanuts setOn:YES animated:NO];
            else if(i == 4)
                [_kosher setOn:YES animated:NO];
            else if(i == 5)
                [_lowfat setOn:YES animated:NO];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
}

- (IBAction)vegetarian:(id)sender
{
    [self togglePref:@"vegetarian" Index:0 State:[sender isOn] ? 1 : 0];
}

- (IBAction)vegan:(id)sender
{
    [self togglePref:@"vegan" Index:1 State:[sender isOn] ? 1 : 0];
}

- (IBAction)diary:(id)sender
{
    [self togglePref:@"dairyfree" Index:2 State:[sender isOn] ? 1 : 0];
}

- (IBAction)peanuts:(id)sender
{
    [self togglePref:@"peanutallergy" Index:3 State:[sender isOn] ? 1 : 0];
}

- (IBAction)kosher:(id)sender
{
    [self togglePref:@"kosher" Index:4 State:[sender isOn] ? 1 : 0];
}

- (IBAction)lowfat:(id)sender
{
    [self togglePref:@"lowfat" Index:5 State:[sender isOn] ? 1 : 0];
}

- (IBAction)logout:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Logged out" message:@"Logged out successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    ECSlidingViewController *slidingController = self.slidingViewController;
    
    [slidingController anchorTopViewToRightAnimated:YES];
    slidingController.topViewController = self.homeViewController;
    [[MenyouApi getInstance] logout];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
}

-(void)togglePref:(NSString*)field Index:(int)index State:(int)state
{
    //Value indicates which setting it is...vegetarian = 0, vegan = 1, dairy = 2, peanuts = 3, kosher = 4, lowfat = 5
    [[MenyouApi getInstance] setPref:field withValue:state withBlock:^(BOOL success) {
        // We do this even if the api call was not successful because if it was not we still wan't the user to see
        // the dishes updated
        [[MenyouApi getInstance].preferences replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d", state]];
        [[MenyouApi getInstance].dynamicPref replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%d", state]];
        [[MenyouApi getInstance] savePrefs];
    }];
}

@end
