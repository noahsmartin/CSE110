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
    }
    return self;
}

@end
