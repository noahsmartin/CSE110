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
#import "ASMediaFocusManager.h"
#import "PropertiesView.h"

@interface DishViewController () <ASMediasFocusDelegate>
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
@property ASMediaFocusManager* mediaManager;
@property int imageCount;
@property CGFloat contentOffset;
@end

@implementation DishViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageCount = 0;
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
    self.mediaManager = [[ASMediaFocusManager alloc] init];
    self.mediaManager.delegate = self;
}

-(void)loadImages
{
    [[MenyouApi getInstance] imageCountForDish:self.dish.identifier withBlock:^(int count) {
        self.scrollView.contentSize = CGSizeMake(count*60, 60);
        self.imageCount = count;
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
        for (UIView* v in [self.scrollView subviews]) {
            if(v != self.loadingLabel)
            {
                [v removeGestureRecognizer:[v gestureRecognizers][0]];
                [v removeFromSuperview];
            }
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
            [self.mediaManager installOnView:imageView];
            [imageView setFrame:CGRectMake(5+(count-1)*60-i*60, 5, 50, 50)];
            [imageView setTag:i];
            [queue addOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString* urlString = [NSString stringWithFormat:@"http://menyouapp.com/getImageThumb.php?id=%@&count=%d", self.dish.identifier, i];
                    [imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"loading"]];
                });
            }];
            [self.scrollView addSubview:imageView];
        }
    }];
}

-(NSURL*)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager URLForView:(UIView *)view
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://menyouapp.com/getFullImage.php?id=%@&position=%ld", self.dish.identifier, (long)[view tag]]];
}

-(UIImage*)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager defaultImageForView:(UIView *)view
{
    return [UIImage imageNamed:@"loadingLarge"];
}

- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameForView:(UIView *)view
{
    return CGRectMake(0, 136.5, 320, 295);
}

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager
{
    return self;
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;
{
    return self.dish.title;
}

- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager
{
    self.contentOffset = self.scrollView.contentOffset.x;

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        [UIApplication sharedApplication].statusBarHidden = YES;
    }];
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    // Enlarging the image resets the scroll view, lets put it back where it should be
    self.scrollView.contentOffset = CGPointMake(self.contentOffset, self.scrollView.contentOffset.y);
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
}

-(void)mediaFocusManagerDidDisappear:(ASMediaFocusManager *)mediaFocusManager
{
    //  This is to make sure the scrollView still scrolls after an image leaves full screen
    self.scrollView.contentSize = CGSizeMake(self.imageCount*60, 60);
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
    [self.propView setAttributeImages:self.dish.properties];
    [self.propView setChefRecommended:self.dish.chefRecommendation];
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
