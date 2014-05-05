//
//  Category.m
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Categories.h"

@implementation Categories

-(instancetype)initWithData:(NSDictionary *)data
{
    if(self = [super init])
    {
        self.title = [data objectForKey:@"title"];
    }
    return self;
}

-(NSString*)description
{
    return self.title;
}

@end
