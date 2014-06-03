//
//  Menu.m
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Menu.h"
#import "Categories.h"
#import "MenyouApi.h"

@implementation Menu

-(int)numberSelected
{
    int count = 0;
    for(Categories* cat in self.categories)
    {
        for(Dish* d in cat.dishes)
        {
            if([d isSelected])
            {
                count++;
            }
        }
    }
    return count;
}

-(NSArray*)selectedItems
{
    NSMutableArray* arr = [NSMutableArray array];
    for(Categories* cat in self.categories)
    {
        for(Dish* d in cat.dishes)
        {
            if([d isSelected])
            {
                [arr addObject:d];
            }
        }
    }
    return arr;
}

-(NSNumber*)totalCost
{
    NSNumber *t = 0;
    NSArray* a = [self selectedItems];
    for(Dish* d in a)
    {
        NSString* p = [[d price] stringByReplacingOccurrencesOfString:@"$" withString:@""];
        t = @([t doubleValue] + [p doubleValue]);
    }
    return t;
}

-(int)topItemCount
{
    int total = 0;
    for (Categories* c in self.categories) {
        if(c.filterCount >= 3)
        {
            total += 3;
            total += 1;  // Add this for the title
        }
        else if(c.filterCount > 0)
        {
            total += c.filterCount;
            total += 1;  // Add this for the title
        }
    }
    return total;
}

-(id)itemForTopPosition:(long)position
{
    // Probably not the best way to do this, the method returns the object used by the controller to update the top items
    long total = 0;
    for (Categories* c in self.categories) {
        if(!c.filterCount)
            continue;
        long startTotal = total;
        if(position == total)
        {
            return c.title;
        }
        if(c.filterCount >= 3)
            total += 3;
        else
            total += c.filterCount;
        if(position <= total)
            return [[c topItems] objectAtIndex:position-startTotal-1];
        total += 1; // Add this for the title
    }
    return nil;
}

-(int)numCategories
{
    return (int) self.categories.count;
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

-(void)reloadReviews
{
    for(Categories* c in self.categories)
    {
        [c reloadReviews];
    }
}

-(void)pickRandomItems
{
    for (Categories* cat in self.categories) {
        int length = (int) cat.filteredDishes.count;
        if(length == 0)
            continue;
        int rand = arc4random() % (length);
        ((Dish*) cat.filteredDishes[rand]).isSelected = YES;
    }
}

-(void)refilterAll
{
    for(Categories* c in self.categories)
    {
        c.filteredDishes = [c filterOutDishes:[MenyouApi getInstance].dynamicPref];
    }
}

@end
