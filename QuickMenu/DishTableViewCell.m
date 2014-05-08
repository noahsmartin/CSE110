//
//  DishTableViewCell.m
//  Menyou
//
//  Created by Noah Martin on 5/6/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "DishTableViewCell.h"

@interface DishTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *background;
@property CAGradientLayer* gradient;
@end

@implementation DishTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.gradient.frame = self.background.bounds;
}

-(void)setColor:(UIColor *)color
{
    [self.background setBackgroundColor:color];
}

-(void)setup
{
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.background.bounds;
    self.gradient.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                              (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                              (id)[[UIColor clearColor] CGColor],
                              (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
    self.gradient.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
    [self.background.layer insertSublayer:self.gradient atIndex:0];
    self.contentView.layer.shadowRadius = 1;
    self.contentView.layer.shadowOpacity = 0.3;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.background.layer.cornerRadius = 10;
    self.background.layer.masksToBounds = YES;
    [self.background setOpaque:YES];
}

- (void)awakeFromNib
{
    [self setup];
}

@end
