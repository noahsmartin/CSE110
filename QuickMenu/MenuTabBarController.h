//
//  MenuTabBarController.h
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"

@interface MenuTabBarController : UITabBarController <UIAlertViewDelegate>

@property (weak) Restaurant* restaurant;

@end
