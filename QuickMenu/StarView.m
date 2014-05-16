//
//  StarView.m
//  Menyou
//
//  Created by Noah Martin on 5/9/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "StarView.h"

@interface StarView()
@property NSArray* images;
@property UILabel* noRating;
@property UILabel* reviewCount;
@end

@implementation StarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setUp];
}

-(void)setRating:(double)rating
{
    _rating = rating;
    if(_rating >= 0)
    {
        int i = 0;
        while(i < 5)
        {
            if(i+1 <= rating)
                [self.images[i] setImage:[UIImage imageNamed:@"starFull"]];
            else if(i < rating)
                [self.images[i] setImage:[UIImage imageNamed:@"starHalf"]];
            else
                [self.images[i] setImage:[UIImage imageNamed:@"starEmpty"]];
            [self.images[i] setHidden:NO];
            i++;
        }
        [self.noRating setHidden:YES];
    }
    else
    {
        [self.noRating setHidden:NO];
        for(UIView *v in self.images)
        {
            [v setHidden:YES];
        }
    }
    [self setNeedsDisplay];
}

-(void)setNumberReviews:(int)numberReviews
{
    _numberReviews = numberReviews;
    if(_numberReviews <= 0)
        [self.reviewCount setHidden:YES];  // No need to show 0 Reviews, this label should just be hidden
    else
    {
        [self.reviewCount setHidden:NO];
        if (_numberReviews == 1)
            self.reviewCount.text = [NSString stringWithFormat:@"1 Review"];
        else
            self.reviewCount.text = [NSString stringWithFormat:@"%d Reviews", _numberReviews];
    }
    [self.reviewCount setFont:[UIFont fontWithName:@"HelveticaNeue-ThinItalic" size: 13]];
    
}

-(void)setUp
{
    NSMutableArray* array = [NSMutableArray array];
    for(int i = 0; i < 5; i++)
        [array addObject:[[UIImageView alloc] initWithImage:nil]];
    int i = 0;
    for(UIImageView *v in array)
    {
        [v setFrame:CGRectMake(i*15, 0, 15, 15)];
        [self addSubview:v];
        i++;
    }
    self.images = array;
    self.noRating = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    self.noRating.text = @"No Ratings";
    [self.noRating setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [self addSubview:self.noRating];
    
    self.reviewCount = [ [UILabel alloc] initWithFrame:CGRectMake(82, 0, 80, 20)]; //-2 for ycoord if center on home. 2 for dish
    [self addSubview:self.reviewCount];
    [self.reviewCount setHidden:YES]; // Hide initalliy because count is 0
}

@end
