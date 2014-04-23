//
//  HomeTableViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "HomeTableViewController.h"
#import "Restaurant.h"

@implementation HomeTableViewController

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.restaurants count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.error == NO_ERROR)
        return 0;
    return 30;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.error == NO_ERROR)
        return nil;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    if(self.error == NO_INTERNET)
        text.text = @"No Internet Connection";
    else if(self.error == NO_LOCATION)
        text.text = @"Cannot Determine Location";
    text.textColor = [UIColor whiteColor];
    text.font = [UIFont fontWithName:@"Helvetica Neue Thin" size:20];
    text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    text.textAlignment = NSTextAlignmentCenter;
    [header addSubview:text];
    [header setBackgroundColor:[UIColor colorWithRed:0.21 green:0.21 blue:0.21 alpha:1]];
    return header;
}

-(void)setRestaurants:(NSArray *)restaurants
{
    _restaurants = restaurants;
    [self.tableView reloadData];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Restaurant* res = ((Restaurant*)[self.restaurants objectAtIndex:indexPath.row]);
    cell.imageView.image = res.image;
    cell.textLabel.text = res.title;
    return cell;
}

@end
