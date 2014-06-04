//
//  DishAttributes.m
//  Menyou
//
//  Created by Joanne T Wu on 6/3/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "PropertiesView.h"
#import "MenyouApi.h"

@interface PropertiesView();
@property (nonatomic)  UILabel* dishAttributes;
@property NSArray* images;
@end

@implementation PropertiesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setUp];
}

-(void)setAttributeImages{
    if([[MenyouApi getInstance].preferences count] == 0)
        [self.dishAttributes setHidden:YES];
    
    else{
        
    }
    
    
    //set numAttributes to only top 3 most important if > 3
    
    [self setNeedsDisplay];
}

-(void)setUp{
    
    NSMutableArray* array = [NSMutableArray array];
    for(int i = 0; i < 8; i++){
        [array addObject:[[UIImageView alloc] initWithImage:nil]];
    }
    
    int i = 0;
    for(UIImageView *v in array){
        [v setFrame:CGRectMake(i*15, 0, 15, 15)];
        [self addSubview:v];
        i++;
    }
    self.images = array;
}

@end
