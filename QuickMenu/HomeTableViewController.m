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
