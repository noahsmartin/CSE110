//
//  FilterTableViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/29/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "FilterTableViewController.h"
#import "MenyouApi.h"

@interface FilterTableViewController ()

@end

@implementation FilterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[MenyouApi getInstance] updatedynamicPref];
    
    for(int row = 0; row < [[MenyouApi getInstance].preferences count] && row < [self.tableView numberOfRowsInSection:0]; row++)
    {
        NSString* state = [[MenyouApi getInstance].preferences objectAtIndex:row];
        if([state isEqualToString:@"1"])
        {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:0];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    [[MenyouApi getInstance].dynamicPref replaceObjectAtIndex:indexPath.row withObject: @"0"];
    [[MenyouApi getInstance] filterUpdated];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    [[MenyouApi getInstance].dynamicPref replaceObjectAtIndex:indexPath.row withObject: @"1"];
    [[MenyouApi getInstance] filterUpdated];
}

@end
