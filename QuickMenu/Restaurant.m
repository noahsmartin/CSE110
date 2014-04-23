//
//  Restaurant.m
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

-(instancetype)initWithData:(NSDictionary*)data
{
  if(self = [super init])
  {
      // TODO: set up restuarant
      self.title = [data objectForKey:@"name"];
      self.identifier = [data objectForKey:@"id"];
      self.rating = [[data objectForKey:@"rating"] doubleValue];
      self.distance = [[data objectForKey:@"distance"] doubleValue];
      self.numberReviews = [[data objectForKey:@"review_count"] doubleValue];
      return self;
  }
  else
      return nil;
}

@end
