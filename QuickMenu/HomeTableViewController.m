//
//  HomeTableViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "HomeTableViewController.h"

@implementation HomeTableViewController

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.titles objectAtIndex:indexPath.row];
    return cell;
}

@end
