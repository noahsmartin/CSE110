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

-(void)pickRandomItems
{
    for (Categories* cat in self.categories) {
        NSLog(@"category loop");
        int length = (int) cat.dishes.count;
        int rand = arc4random() % (length);
        ((Dish*) cat.dishes[rand]).isSelected = YES;
    }
}


@end
