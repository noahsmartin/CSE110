//
//  MyMenuViewController.h
//  Menyou
//
//  Created by Noah Martin on 4/22/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"

@interface MyMenuViewController : UIViewController

@property (weak, nonatomic) Menu* myMenu;  // Weak reference to the Menu, each item in the menu may be selected, this will iterate through them

@end
