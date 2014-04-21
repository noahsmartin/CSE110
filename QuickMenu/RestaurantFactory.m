//
//  RestaurantFactory.m
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//


#import "RestaurantFactory.h"
#import "Restaurant.h"

@implementation RestaurantFactory

-(NSMutableArray*)restaurantsForData:(NSData *)data
{
    if(!data)
        return nil;
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for(NSDictionary *item in [json objectForKey:@"businesses"])
    {
      // TODO: add checks for if it is a restuaraunt and if it is not closed
      [list addObject:[[Restaurant alloc] initWithData:item]];
    }
    return list;
    // TODO: have this start a new thread that loads the images then calls the callback
}

@end
