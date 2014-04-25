//
//  RestaurantFactory.m
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//


#import "RestaurantFactory.h"
#import "Restaurant.h"

@interface RestaurantFactory()
@property (weak, nonatomic) id<RestaurantFactoryDelegate> delegate;
@end

@implementation RestaurantFactory

-(instancetype)initWithDelegate:(id<RestaurantFactoryDelegate>)delegate
{
    if(self = [super init])
    {
        self.delegate = delegate;
        return self;
    }
    return nil;
}

-(NSMutableArray*)restaurantsForData:(NSData *)data withOldList:(NSArray*)previousList
{
    if(!data)
        return nil;
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableDictionary* previous = [[NSMutableDictionary alloc] init];
    for(Restaurant* r in previousList)
    {
        [previous setObject:r forKey:r.identifier];
    }
    for(NSDictionary *item in [json objectForKey:@"businesses"])
    {
      if(![[item objectForKey:@"is_closed"] boolValue])
      {
          Restaurant* restaurant = [[Restaurant alloc] initWithData:item];
          Restaurant* r = nil;
          if((r = [previous objectForKey:restaurant.identifier]))
          {
              [list addObject:r];
              continue;  // This restaurant was already found, don't need to reload it just add the old one
          }
          // We don't want to show a restaurant that does not have a picture
          if(!restaurant.imageUrl)
              continue;
          [list addObject:restaurant];
          // Use weak references in the block
          __weak Restaurant* tempRestaurant = restaurant;
          __weak RestaurantFactory* weakSelf = self;
          dispatch_queue_t newQueue = dispatch_queue_create("downloadQueue", NULL);
          dispatch_async(newQueue, ^{
              tempRestaurant.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempRestaurant.imageUrl]]];
              [weakSelf.delegate loadedDataForId:tempRestaurant.identifier];
          });
      }
    }
    return list;
    // TODO: have this start a new thread that loads the images then calls the callback
}

@end
