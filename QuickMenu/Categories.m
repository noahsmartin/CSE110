//
//  Category.m
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Categories.h"
#import "Dish.h"
#import "MenyouApi.h"

@implementation Categories

-(instancetype)initWithData:(NSDictionary *)data
{
    if(self = [super init])
    {
        self.title = [data objectForKey:@"title"];
        NSMutableArray* arr = [[NSMutableArray alloc] init];
        NSArray *a = [data objectForKey:@"dishes"];
        for(NSDictionary* d in a)
        {
            [arr addObject:[[Dish alloc] initWithData:d]];
        }

        self.dishes = arr;
        self.filteredDishes = [self filterOutDishes:[MenyouApi getInstance].dynamicPref];
    }
    return self;
}

-(void)reloadReviews
{
    for(Dish* d in self.dishes)
    {
        [d reloadReviews];
    }
}

-(NSArray*)topItems
{
    return [self.dishes sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Dish* d1 = obj1;
        Dish* d2 = obj2;
        if([d1 wilsonScore] > [d2 wilsonScore])
        {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
        
    }];
}

-(NSInteger)count
{
    return self.dishes.count;
}

-(NSInteger)filterCount
{
    return [self.filteredDishes count];
}

-(NSString*)description
{
    return self.title;
}

-(void)removeDish:(id)dish
{
    NSMutableArray* arr = [self.dishes mutableCopy];
    [arr removeObject:dish];
    self.dishes = arr;
    arr = [self.filteredDishes mutableCopy];
    if([arr containsObject:dish])
    {
        [arr removeObject:dish];
        self.filteredDishes = arr;
    }
}

-(NSMutableArray*) filterOutDishes:(NSMutableArray*)filters
{
    NSMutableArray* tempresult = [[NSMutableArray alloc] init];
    for(Dish* d in self.dishes)
    {
        [tempresult addObject:d];
        for(int i = 0; i < [filters count]; i++)
        {
            if([[filters objectAtIndex:i] isEqualToString:@"1"])
            {
                if([[d.properties objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:NO]])
                {
                    [tempresult removeObject:d];
                    break;
                }
            }
        }
    }

    return tempresult;
}

@end
