//
//  LeftTableViewController.h
//  Menyou
//
//  Created by Noah Martin on 4/26/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
@end
