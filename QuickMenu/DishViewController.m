//
//  DishViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/10/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "DishViewController.h"
#import "StarView.h"
#import "MenyouApi.h"

@interface DishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *yourReview;
@property (weak, nonatomic) IBOutlet StarView *yourReviewStars;
@property (weak, nonatomic) IBOutlet UIButton *leaveReviewButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionView;

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
    self.descriptionView.text = self.dish.itemDescription;
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.dish.myRating >= 0) {
        [self.leaveReviewButton setHidden:YES];
        [self.yourReview setHidden:NO];
        [self.yourReviewStars setHidden:NO];
        self.yourReviewStars.rating = self.dish.myRating;
    }
    else
    {
        [self.leaveReviewButton setHidden:NO];
        [self.yourReview setHidden:YES];
        [self.yourReviewStars setHidden:YES];
    }
}

- (IBAction)leaveReview:(id)sender {
    if([[MenyouApi getInstance] loggedIn])
    {
        // TODO: leave a review
    }
    else
    {
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"] animated:YES completion:^{}];
    }
}

- (IBAction)select:(id)sender {
    self.dish.isSelected = !self.dish.isSelected;
    if(self.dish.isSelected)
        [((UIButton*) sender) setBackgroundImage:[UIImage imageNamed:@"checkSelectedBlack"] forState:UIControlStateNormal];
    else
        [((UIButton*) sender) setBackgroundImage:[UIImage imageNamed:@"checkUnselectedBlack"] forState:UIControlStateNormal];
}

@end
