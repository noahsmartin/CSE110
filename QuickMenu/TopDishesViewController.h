//
//  TopDishesViewController.h
//  Menyou
//
//  Created by Noah Martin on 5/20/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"

@interface TopDishesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property Menu* menu;

@end
