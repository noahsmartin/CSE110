//
//  HomeTableViewCell.m
//  Menyou
//
//  Created by Noah Martin on 4/29/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "StarView.h"

@interface HomeTableViewCell()
@property (weak, nonatomic) IBOutlet StarView *starView;
@end

@implementation HomeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(void)setup {
    self.mainImage.layer.cornerRadius = 8;
    self.mainImage.layer.borderWidth = 1;
    self.mainImage.layer.masksToBounds = YES;
    self.mainImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    [self.mainImage setOpaque:YES];
}

-(void)setRating:(double)rating
{
    self.starView.rating = rating;
}

-(void)setReviewCount:(int)reviewCount
{
    self.starView.numberReviews = reviewCount;
}

- (void)awakeFromNib
{
    [self setup];
}

@end
