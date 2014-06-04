//
//  DishViewController.h
//  Menyou
//
//  Created by Noah Martin on 5/10/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dish.h"
#import "PropertiesView.h"

@interface DishViewController : UIViewController

@property (weak) Dish* dish;
@property NSString* restaurant;
@property (weak, nonatomic) IBOutlet PropertiesView *propView;

@end
