//
//  HomeTableViewController.h
//  QuickMenu
//
//  Created by Noah Martin on 4/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSArray *restaurants; // An array of Restaurant objects

@end
