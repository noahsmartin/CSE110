//
//  CategoryViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/5/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "CategoryViewController.h"
#import "DishTableViewCell.h"
#import "DishViewController.h"

@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 104, 320, 0.5)];
    view.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.4];
    [self.view addSubview:view];
    self.titleLabel.text = self.title;
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
    cell.data = self.category.dishes[indexPath.row];
    cell.delegate = self;
    [cell setDishSelected:((Dish*) self.category.dishes[indexPath.row]).isSelected];
    return cell;
}

-(void)itemRemoved:(id)cell
{
    NSUInteger index = [self.category.dishes indexOfObject:((DishTableViewCell*) cell).data];
    [self.category removeDish:((DishTableViewCell*) cell).data];
    [self.categoryTableView beginUpdates];
    [self.categoryTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationRight];
    [self.categoryTableView endUpdates];
}

-(void)itemSelected:(id)cell
{
    Dish* d = ((Dish*) ((DishTableViewCell*) cell).data);
    d.isSelected = !d.isSelected;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"dishDetailSegue"])
    {
        ((DishViewController*) segue.destinationViewController).dish = ((DishTableViewCell*) sender).data;
    }
}

@end
