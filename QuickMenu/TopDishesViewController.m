//
//  TopDishesViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/20/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "TopDishesViewController.h"
#import "DishTableViewCell.h"
#import "Dish.h"

@interface TopDishesViewController ()

@end

@implementation TopDishesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.menu itemForTopPosition:indexPath.row];
    if([data isKindOfClass:[NSString class]])
    {
        return 90;
    }
    return 90;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu topItemCount];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DishCell";
    DishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[DishTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    id data = [self.menu itemForTopPosition:indexPath.row];
    if([data isKindOfClass:[NSString class]])
    {
        cell.titleLabel.text = data;
    }
    else
    {
        cell.titleLabel.text = ((Dish*) data).title;
    }
    return cell;
}

@end
