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
#import "AddRatingViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *yourReview;
@property (weak, nonatomic) IBOutlet StarView *yourReviewStars;
@property (weak, nonatomic) IBOutlet UIButton *leaveReviewButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionView;
@property BOOL sentLogin;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@end

@implementation DishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.title = self.dish.title;
    self.titleView.text = self.title;
    [self updateUI];
    self.descriptionView.text = self.dish.itemDescription;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.scrollView.layer.borderWidth = 0.5;
    self.scrollView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.scrollView.layer.shadowOffset = CGSizeMake(0, 2);
    self.scrollView.layer.shadowRadius = 4;
    self.loadingLabel.text = @"Loading Images...";
    self.loadingLabel.hidden = NO;
}

-(void)loadImages
{
    [[MenyouApi getInstance] imageCountForDish:self.dish.identifier withBlock:^(int count) {
        self.scrollView.contentSize = CGSizeMake(count*60, 60);
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        for (UIView* v in [self.scrollView subviews]) {
            if(v != self.loadingLabel)
                [v removeFromSuperview];
        }

        if(count > 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loadingLabel.hidden = YES;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loadingLabel.text = @"No Images Found";
            });
        }
        for(int i = count-1; i >= 0; i--)
        {
            UIImageView* imageView = [[UIImageView alloc] init];
            [imageView setFrame:CGRectMake(5+(count-1)*60-i*60, 5, 50, 50)];
            [queue addOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* urlString = [NSString stringWithFormat:@"http://menyouapp.com/getImageThumb.php?id=%@&count=%d", self.dish.identifier, i];
                    [imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"RoudIcon"]];
                });
            }];
            [self.scrollView addSubview:imageView];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateUI];
}

-(void)updateUI
{
    self.starView.rating = self.dish.rating;
    self.starView.numberReviews = self.dish.numRatings;
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
    [self setButtonImage:self.selectedButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(self.sentLogin)
    {
        if([[MenyouApi getInstance] loggedIn])
        {
            [self presentAddRating];
        }
    }
    else {
        [self loadImages];
    }
    self.sentLogin = NO;
}

-(void)presentAddRating
{
    if(self.dish.myRating >= 0)
        return;
    UINavigationController* vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"addRatingViewController"];
    ((AddRatingViewController*) (vc.topViewController)).title = self.dish.title;
    ((AddRatingViewController*) (vc.topViewController)).dish = self.dish;
    ((AddRatingViewController*) (vc.topViewController)).restaurant = self.restaurant;
    [self presentViewController:vc animated:YES completion:^{}];
}

- (IBAction)leaveReview:(id)sender {
    if([[MenyouApi getInstance] loggedIn])
    {
        [self presentAddRating];
    }
    else
    {
        self.sentLogin = YES;
        [self presentViewController:[[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"] animated:YES completion:^{}];
    }
}

- (IBAction)select:(id)sender {
    self.dish.isSelected = !self.dish.isSelected;
    [self setButtonImage:sender];
}

-(void)setButtonImage:(UIButton*)button
{
    if(self.dish.isSelected)
        [button setBackgroundImage:[UIImage imageNamed:@"checkselectedLarge"] forState:UIControlStateNormal];
    else
        [button setBackgroundImage:[UIImage imageNamed:@"checkunselectedLarge"] forState:UIControlStateNormal];
}

@end
