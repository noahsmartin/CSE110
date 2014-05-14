//
//  SettingsViewController.h
//  Menyou
//
//  Created by Noah Martin on 5/10/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "LeftTableViewController.h"

@interface SettingsViewController : UIViewController <ECSlidingViewControllerDelegate>
@property UIViewController* homeViewController;
@end
