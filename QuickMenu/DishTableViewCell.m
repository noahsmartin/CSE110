//
//  DishTableViewCell.m
//  Menyou
//
//  Created by Noah Martin on 5/6/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "DishTableViewCell.h"

@implementation DishTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIView *mainView = self.contentView.subviews[0];
    self.contentView.layer.shadowRadius = 1;
    self.contentView.layer.shadowOpacity = 0.4;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
    mainView.layer.cornerRadius = 10;
    mainView.layer.masksToBounds = YES;
    [mainView setOpaque:YES];
}

- (void)awakeFromNib
{
    [self setup];
}

@end
