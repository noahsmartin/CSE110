//
//  Dishes.m
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Dish.h"
#import "MenyouApi.h"

@implementation Dish

-(instancetype)initWithData:(NSDictionary *)data
{
    if(self = [super init])
    {
        self.title = [data objectForKey:@"title"];
        self.price = [NSString stringWithFormat:@"%@", [data objectForKey:@"price"]];
        self.itemDescription = [data objectForKey:@"description"];
        self.chefRecommendation = [data objectForKey:@"chefrecommended"];
        self.spicyProp = [data objectForKey:@"spicemeter"];
        
        self.properties = [[NSMutableArray alloc] init];
        
        NSString* tempdata = [data objectForKey:@"vegetarian"];
        if([tempdata isEqualToString:@"1"])
            [self.properties addObject: [NSNumber numberWithBool:YES]];
        else
            [self.properties addObject: [NSNumber numberWithBool:NO]];
       
        tempdata = [data objectForKey:@"vegan"];
        if([tempdata isEqualToString:@"1"])
            [self.properties addObject: [NSNumber numberWithBool:YES]];
        else
            [self.properties addObject: [NSNumber numberWithBool:NO]];
        
        tempdata = [data objectForKey:@"dairyfree"];
        if([tempdata isEqualToString:@"1"])
            [self.properties addObject: [NSNumber numberWithBool:YES]];
        else
            [self.properties addObject: [NSNumber numberWithBool:NO]];
        
        tempdata = [data objectForKey:@"peanutallergy"];
        if([tempdata isEqualToString:@"1"])
            [self.properties addObject: [NSNumber numberWithBool:YES]];
        else
            [self.properties addObject: [NSNumber numberWithBool:NO]];
        
        tempdata = [data objectForKey:@"kosher"];
        if([tempdata isEqualToString:@"1"])
            [self.properties addObject: [NSNumber numberWithBool:YES]];
        else
            [self.properties addObject: [NSNumber numberWithBool:NO]];
        
        tempdata = [data objectForKey:@"lowfat"];
        if([tempdata isEqualToString:@"1"])
            [self.properties addObject: [NSNumber numberWithBool:YES]];
        else
            [self.properties addObject: [NSNumber numberWithBool:NO]];
        
        if([data objectForKey:@"rating"])
        {
            self.rating = [[data objectForKey:@"rating"] doubleValue];
            // This assumes if ratings are found review_count is set also
            self.numRatings = [[data objectForKey:@"review_count"] intValue];
            if(self.numRatings == 0)
                self.rating = -1;
        }
        else
        {
            self.rating = -1;
            self.numRatings = 0;
        }
        self.identifier = [data objectForKey:@"dishid"];
        [self reloadReviews];
    }
    return self;
}

-(void)addUserRating:(int)userRating
{
    self.myRating = userRating;
    self.rating = (self.myRating + self.rating*self.numRatings)/(++self.numRatings);
    
}

-(void)reloadReviews
{
    self.myRating = [[MenyouApi getInstance] getReviewFor:self.identifier];
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
