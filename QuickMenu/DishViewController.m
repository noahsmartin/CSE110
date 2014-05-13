//
//  DishViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/10/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "DishViewController.h"
#import "StarView.h"

@interface DishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = self.dish.title;
    self.titleView.text = self.title;
    self.starView.rating = self.dish.rating;
    self.scrollView.contentSize = CGSizeMake(272, 550);
    
}

- (IBAction)select:(id)sender {
    self.dish.isSelected = !self.dish.isSelected;
    if(self.dish.isSelected)
        [((UIButton*) sender) setBackgroundImage:[UIImage imageNamed:@"checkSelectedBlack"] forState:UIControlStateNormal];
    else
        [((UIButton*) sender) setBackgroundImage:[UIImage imageNamed:@"checkUnselectedBlack"] forState:UIControlStateNormal];
}

@end
