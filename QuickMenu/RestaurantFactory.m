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

-(NSMutableArray*)loadRestaurantsForData:(NSData*)data
{
    if(!data)
        return nil;
    NSMutableArray* list = [[NSMutableArray alloc] init];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for(NSDictionary *item in [json objectForKey:@"businesses"])
    {
        if(![[item objectForKey:@"is_closed"] boolValue])
        {
            Restaurant* restaurant = [[Restaurant alloc] initWithData:item];
            [list addObject:restaurant];
        }
    }
    return list;
}

-(NSMutableArray*)restaurantsForData:(NSData *)data withOldList:(NSArray*)previousList
{
    if(!data)
        return nil;
    NSMutableArray* list = [self loadRestaurantsForData:data];//[[NSMutableArray alloc] init];
    NSMutableDictionary* previous = [[NSMutableDictionary alloc] init];
    for(Restaurant* r in previousList)
    {
        [previous setObject:r forKey:r.identifier];
    }
    for (int i = 0; i < [list count]; i++) {
        Restaurant* restaurant = list[i];
        Restaurant* r = nil;
        if((r = [previous objectForKey:restaurant.identifier]))
        {
            // This change is what was discussed in code review 1A
            if([r.imageUrl isEqualToString:restaurant.imageUrl] && r.image)
            {
                restaurant.image = r.image;
                continue;  // This restaurant was already found, don't need to reload it just add the old one
            }
        }
        // We don't want to show a restaurant that does not have a picture
        if(!restaurant.imageUrl)
        {
            [list removeObjectAtIndex:i];
            i--;
            continue;
        }
        // Use weak references in the block
        __weak Restaurant* tempRestaurant = restaurant;
        __weak RestaurantFactory* weakSelf = self;
        dispatch_queue_t newQueue = dispatch_queue_create("downloadQueue", NULL);
        dispatch_async(newQueue, ^{
            tempRestaurant.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempRestaurant.imageUrl]]];
            [weakSelf.delegate loadedDataForId:tempRestaurant.identifier];
        });
    }
    return list;
}

@end
