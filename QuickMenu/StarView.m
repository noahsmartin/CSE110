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
    int i = 0;
    while(i < 5)
    {
        if(i+1 <= rating)
            [self.images[i] setImage:[UIImage imageNamed:@"starFull"]];
        else if(i < rating)
            [self.images[i] setImage:[UIImage imageNamed:@"starHalf"]];
        else
            [self.images[i] setImage:[UIImage imageNamed:@"starEmpty"]];
        i++;
    }
    [self setNeedsDisplay];
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
}

@end
