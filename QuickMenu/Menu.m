//
//  Menu.m
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Menu.h"
#import "Categories.h"

@implementation Menu

-(int)numberSelected
{
    int count = 0;
    for(Categories* cat in self.categories)
    {
        for(Dish* d in cat.dishes)
        {
            if([d isSelected])
                count++;
        }
    }
    return count;
}

-(instancetype)initWithData:(NSDictionary *)data
{
    if(self = [super init])
    {
        NSMutableArray* categories = [[NSMutableArray alloc] init];
        for(NSDictionary* category in [data objectForKey:@"categories"])
        {
            Categories* newCategory = [[Categories alloc] initWithData:category];
            [categories addObject:newCategory];
        }
        self.categories = categories;
    }
    return self;
}

-(NSString*)description
{
    return [self.categories description];
}

-(void)pickRandomItems
{
    for (Categories* cat in self.categories) {
        int length = (int) cat.dishes.count;
        int rand = arc4random() % (length);
        ((Dish*) cat.dishes[rand]).isSelected = YES;
    }
}


@end
