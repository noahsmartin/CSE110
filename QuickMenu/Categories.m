//
//  Category.m
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Categories.h"
#import "Dish.h"

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
    }
    return self;
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

-(NSString*)description
{
    return self.title;
}

-(void)removeDish:(id)dish
{
    NSMutableArray* arr = [self.dishes mutableCopy];
    [arr removeObject:dish];
    self.dishes = arr;
}

@end
