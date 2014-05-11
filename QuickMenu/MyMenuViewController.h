//
//  MyMenuViewController.h
//  Menyou
//
//  Created by Noah Martin on 4/22/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
#import "Menu.h"

@interface MyMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Restaurant* restaurant;  // Weak reference to the Restaurant

@end
