//
//  TopDishesViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/20/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "TopDishesViewController.h"
#import "Dish.h"
#import "DishViewController.h"

@interface TopDishesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.menu itemForTopPosition:indexPath.row];
    if([data isKindOfClass:[NSString class]])
    {
        return 40;
    }
    return 90;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.menu refilterAll];
    [self.table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menu topItemCount];
}

-(UIColor*)colorForIndex:(NSInteger) index {
    NSUInteger itemCount = self.menu.topItemCount;
    float val = 0.288 + ((float)index / (float)itemCount) * 0.3;
    return [UIColor colorWithRed: 1.0 green:val blue:0.20 alpha:1.0];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DishTableViewCell *cell;
    
    id data = [self.menu itemForTopPosition:indexPath.row];
    if([data isKindOfClass:[NSString class]])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
        if (cell == nil) {
            cell = [[DishTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TitleCell"];
        }
        UILabel* label = ((UILabel*) [[cell contentView] subviews][0]);
        label.text = data;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4];
        [cell.contentView addSubview:view];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DishCell"];
        if (cell == nil) {
            cell = [[DishTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DishCell"];
        }
        Dish* dish = ((Dish*) data);
        cell.titleLabel.text = dish.title;
        [cell setColor:[self colorForIndex:indexPath.row]];
        cell.descriptionLabel.text = dish.itemDescription;
        // Intentionally not explicitly adding a $, this should be a property of the dish the restaurant owner enters, also
        // by adding a $ we would clearly not be supporting other currencies, this way we still are.
        cell.priceLabel.text = dish.price;
        cell.data = dish;
        cell.delegate = self;
        [cell setDishSelected:dish.isSelected];
        cell.starView.rating = dish.rating;
    }
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self.menu itemForTopPosition:indexPath.row];
    if([data isKindOfClass:[NSString class]])
        return NO;
    return YES;
}

-(void)itemSelected:(id)cell
{
    Dish* d = ((Dish*) ((DishTableViewCell*) cell).data);
    d.isSelected = !d.isSelected;
}

-(BOOL)canRemove:(id)cell
{
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"dishDetailSegue"])
    {
        ((DishViewController*) segue.destinationViewController).dish = ((DishTableViewCell*) sender).data;
        ((DishViewController*) segue.destinationViewController).restaurant = self.restaurant;
    }
}

-(void)updateTableView
{
    [self.table reloadData];
}

@end
