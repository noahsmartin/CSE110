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
@property (nonatomic)  UILabel* properties;
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

-(void)setAttributeImages:(NSArray*)dishProps{
    for(int i = 0; i < sizeof(dishProps); i++){
        [self.images[i] setImage:nil];
    }
    
    int i = 0;
    if([[dishProps objectAtIndex:0] boolValue]){
        [self.images[i] setImage:[UIImage imageNamed:@"0veggie"]];
        i++;
    }
    if([[dishProps objectAtIndex:1] boolValue]){
        [self.images[i] setImage:[UIImage imageNamed:@"0vegan"]];
        i++;
    }
    if([[dishProps objectAtIndex:2] boolValue]){
        [self.images[i] setImage:[UIImage imageNamed:@"0dairyfree"]];
        i++;
    }
    if([[dishProps objectAtIndex:3] boolValue]){
        [self.images[i] setImage:[UIImage imageNamed:@"0peanut"]];
        i++;
    }
    if([[dishProps objectAtIndex:4] boolValue]){
        [self.images[i] setImage:[UIImage imageNamed:@"0kosher"]];
        i++;
    }
    if([[dishProps objectAtIndex:5] boolValue]){
        [self.images[i] setImage:[UIImage imageNamed:@"0lowfat"]];
        i++;
    }
    
    if([self.chefRecommended isEqualToString:@"1"])
    {
        NSLog(@"chef recommend");
        [self.images[i] setImage:[UIImage imageNamed:@"0chef"]];
    }

    [self setNeedsDisplay];
}

-(void)setUp{
    
    NSMutableArray* array = [NSMutableArray array];
    for(int i = 0; i < 8; i++){
        [array addObject:[[UIImageView alloc] initWithImage:nil]];
    }
    
    int i = 0;
    for(UIImageView *v in array){
        [v setFrame:CGRectMake(i*16, 0, 15, 15)];
        [self addSubview:v];
        i++;
    }
    self.images = array;
}

@end
