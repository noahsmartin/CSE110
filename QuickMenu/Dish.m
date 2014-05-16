//
//  Dishes.m
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Dish.h"

@implementation Dish

-(instancetype)initWithData:(NSDictionary *)data
{
    if(self = [super init])
    {
        self.title = [data objectForKey:@"title"];
        self.price = [[data objectForKey:@"price"] stringValue];
        self.itemDescription = [data objectForKey:@"description"];
        if([data objectForKey:@"rating"])
        {
            self.rating = [[data objectForKey:@"rating"] intValue];
            // This assumes if ratings are found review_count is set also
            self.numRatings = [[data objectForKey:@"review_count"] intValue];
        }
        else
        {
            self.rating = -1;
            self.numRatings = 0;
        }
        self.myRating = -1;
        self.identifier = 0;
    }
    return self;
}

@end
