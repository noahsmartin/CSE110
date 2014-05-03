//
//  Restaurant.m
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "Restaurant.h"
#import "Categories.h"
#import "Dish.h"

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
      self.distance = [[data objectForKey:@"distance"] doubleValue] * 0.000621371;
      self.numberReviews = [[data objectForKey:@"review_count"] doubleValue];
      self.imageUrl = [data objectForKey:@"image_url"];
      NSDictionary* loc = [data objectForKey:@"location"];
      NSArray* address = [loc objectForKey:@"address"];
      NSArray* neighborhoods = [loc objectForKey:@"neighborhoods"];
      NSString *line1 = @"", *line2 = @"";
      if([address count])
          line1 = [address objectAtIndex:0];
      if([neighborhoods count])
          line2 = [neighborhoods objectAtIndex:0];
      
      self.location = [NSString stringWithFormat:@"%@, %@", line1, line2];
      self.menu = [[Menu alloc] init];
      Categories* c = [[Categories alloc] init];
      Dish* d = [[Dish alloc] init];
      c.dishes = @[d];
      Categories* c1 = [[Categories alloc] init];
      Dish* d1 = [[Dish alloc] init];
      c1.dishes = @[d1];
      self.menu.categories = @[c, c1];
      return self;
  }
  else
      return nil;
}

-(NSString*)description
{
    return self.identifier;
}

@end
