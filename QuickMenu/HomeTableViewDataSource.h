//
//  HomeTableViewController.h
//  QuickMenu
//
//  Created by Noah Martin on 4/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NO_ERROR 0
#define NO_LOCATION 1
#define NO_INTERNET 2

@interface HomeTableViewDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSArray *restaurants; // An array of Restaurant objects

@property int error;

@end
