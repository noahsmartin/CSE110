//
//  LeftTableViewController.m
//  Menyou
//
//  Created by Noah Martin on 4/26/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "LeftTableViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@implementation LeftTableViewController
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DrawerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    // Hack because I didn't want to subclass UIView for this... probably should be fixed later
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 240, 0.5)];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    UIView *mainView = [[[[cell subviews] objectAtIndex:0] subviews] objectAtIndex:1];
    [mainView addSubview:view];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.slidingViewController resetTopViewAnimated:YES];
}

@end
