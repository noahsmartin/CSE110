//
//  AddRatingViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "AddRatingViewController.h"
#import "StarView.h"
#import "MenyouApi.h"

@interface AddRatingViewController ()
@property (weak, nonatomic) IBOutlet StarView *rating;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property int myRating;
@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;
@property UIActivityIndicatorView *activityIndicator;

@end

@implementation AddRatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)cancel:(id)sender {
    if(self.myRating > 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to cancel your review?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Continue reviewing", nil] show];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (IBAction)save:(id)sender {
    [[MenyouApi getInstance] addReview:self.myRating forRestaurant:self.restaurant item:[NSString stringWithFormat:@"%d", self.dish.identifier] withBlock:^(BOOL success) {
        [self.activityIndicator stopAnimating];
        if(success)
        {
            self.dish.myRating = self.myRating;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not post review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
    [self.activityIndicator startAnimating];
}

- (IBAction)oneStar:(id)sender {
    self.myRating = 1;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
}

- (IBAction)twoStars:(id)sender {
    self.myRating = 2;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
}

- (IBAction)threeStars:(id)sender {
    self.myRating = 3;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
}

- (IBAction)fourStars:(id)sender {
    self.myRating = 4;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmpty"] forState:UIControlStateNormal];
}

- (IBAction)fiveStars:(id)sender {
    self.myRating = 5;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starFull"] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.rating.rating = self.dish.rating;
    self.rating.numberReviews = self.dish.numRatings;
    self.description.text = self.dish.itemDescription;
    self.myRating = 0;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = [UIColor blackColor];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
}

@end
