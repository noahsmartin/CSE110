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
            self.rating = [[data objectForKey:@"rating"] doubleValue];
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

-(double)wilsonScore
{
    if(self.numRatings == 0)
        return -1;
    double average = self.rating - 1;  // Start rating at 0
    average = average/4;  // Make all rating scalled from 0 - 1
    double z = 1.96;  // z-score for 95%
    double scaled = (average + (z*z/(2*self.numRatings)) - z*sqrt(average*(1-average)/self.numRatings + z*z/(4*self.numRatings*self.numRatings)))/(1+z*z/self.numRatings); // the formula...
    return scaled; // No need to scale score back up because this value will not be displayed
}

@end
