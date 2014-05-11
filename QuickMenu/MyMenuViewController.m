//
//  MyMenuViewController.m
//  Menyou
//
//  Created by Noah Martin on 4/22/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MyMenuViewController.h"
#import "Dish.h"

@implementation MyMenuViewController

-(void)viewDidLoad
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.restaurant.menu.numberSelected + 1;
}

- (IBAction)share:(id)sender {
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[self.restaurant.title] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"priceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(indexPath.row != self.restaurant.menu.numberSelected)
    {
        Dish* d = [self.restaurant.menu selectedItems][indexPath.row];
        cell.textLabel.text = d.title;
        cell.detailTextLabel.text = d.price;
    }
    else
    {
        cell.textLabel.text = @"Total:";
        cell.detailTextLabel.text = [self.restaurant.menu.totalCost stringValue];
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
