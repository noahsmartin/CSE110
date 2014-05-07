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
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView setOpaque:YES];
}

- (void)awakeFromNib
{
    [self setup];
}

@end
