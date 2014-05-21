//
//  TopDishesViewController.h
//  Menyou
//
//  Created by Noah Martin on 5/20/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "DishTableViewCell.h"

@interface TopDishesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DishTableViewDelegate>

@property Menu* menu;
@property NSString* restaurant;

@end
