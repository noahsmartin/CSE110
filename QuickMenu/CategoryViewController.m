//
//  CategoryViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/5/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "CategoryViewController.h"
#import "DishTableViewCell.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

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
    self.titleLabel.text = self.title;
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.category.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.category.count;
    float val = 0.288 + ((float)index / (float)itemCount) * 0.2;
    return [UIColor colorWithRed: 1.0 green:val blue:0.20 alpha:1.0];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"DishCell";
    DishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[DishTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    [cell setColor:[self colorForIndex:indexPath.row]];
    cell.titleLabel.text = ((Dish*) self.category.dishes[indexPath.row]).title;
    cell.descriptionLabel.text = ((Dish*) self.category.dishes[indexPath.row]).itemDescription;
    cell.priceLabel.text = ((Dish*) self.category.dishes[indexPath.row]).price;
    return cell;
}

@end
