//
//  HomeTableViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/15/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "HomeTableViewDataSource.h"
#import "Restaurant.h"
#import "HomeTableViewCell.h"

@implementation HomeTableViewDataSource

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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"HomeTableViewCell";
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    Restaurant* res = ((Restaurant*)[self.restaurants objectAtIndex:indexPath.row]);
    cell.mainImage.image = res.image;
    cell.title.text = res.title;
    NSString* dist;
    if(res.distance < 0.1)
        dist = [NSString stringWithFormat:@"%3.0f ft", res.distance * 5280];
    else
        dist = [NSString stringWithFormat:@"%3.2f mi", res.distance];
    cell.distance.text = dist;
    [cell setRating:res.rating];
    return cell;
}

@end
