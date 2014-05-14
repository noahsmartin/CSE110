//
//  LeftTableViewController.m
//  Menyou
//
//  Created by Noah Martin on 4/26/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "LeftTableViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ECSlidingSegue.h"
#import "MenyouApi.h"
#import "SettingsViewController.h"

@interface LeftTableViewController()
@property UIViewController* homeViewController;
@end

@implementation LeftTableViewController
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.homeViewController = self.slidingViewController.topViewController;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier;
    if(indexPath.row == 0){
        simpleTableIdentifier = @"DrawerCell";
    }
    else simpleTableIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    // Hack because I didn't want to subclass UIView for this... probably should be fixed later
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 240, 0.5)];
    [view setBackgroundColor:[UIColor darkGrayColor]];
    UIView *mainView = [[[[cell subviews] objectAtIndex:0] subviews] objectAtIndex:1];
    [mainView addSubview:view];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor darkGrayColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        self.slidingViewController.topViewController = self.homeViewController;
        [self.slidingViewController resetTopViewAnimated:YES];
    }
    else{
        if([[MenyouApi getInstance] loggedIn])
        {
            UINavigationController* settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
            ((SettingsViewController*) settingsViewController.topViewController).homeViewController = self.homeViewController;
            self.slidingViewController.topViewController = settingsViewController;
            [self.slidingViewController resetTopViewAnimated:YES];
        }
        else
        {
            [self presentViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"] animated:YES completion:^{
                // Return to the home MVC
                [self.slidingViewController resetTopViewAnimated:YES];
            }];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
