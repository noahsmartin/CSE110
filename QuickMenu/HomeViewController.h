//
//  HomeViewController.h
//  QuickMenu
//
//  Created by Noah Martin on 4/14/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RestaurantFactory.h"
#import "ECSlidingViewController.h"

@interface HomeViewController : UITableViewController <CLLocationManagerDelegate, NSURLConnectionDataDelegate,
    RestaurantFactoryDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,
    ECSlidingViewControllerDelegate>

@end
