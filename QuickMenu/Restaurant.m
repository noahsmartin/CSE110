//
//  Restaurant.m
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Restaurant.h"

#define DEBUG_Restaurant NO

@implementation Restaurant

-(instancetype)initWithData:(NSDictionary*)data
{
  if(self = [super init])
  {
      // TODO: set up restuarant
      if(DEBUG_Restaurant)
          NSLog(@"%@", data);
      self.title = [data objectForKey:@"name"];
      self.identifier = [data objectForKey:@"id"];
      self.rating = [[data objectForKey:@"rating"] doubleValue];
      self.distance = [[data objectForKey:@"distance"] doubleValue];
      self.numberReviews = [[data objectForKey:@"review_count"] doubleValue];
      self.imageUrl = [data objectForKey:@"image_url"];
      return self;
  }
  else
      return nil;
}

@end
