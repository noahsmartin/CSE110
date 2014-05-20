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
    self.usernameView.text = [temp stringByAppendingString:[MenyouApi getInstance].username];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
}

- (IBAction)logout:(id)sender {
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


@end
