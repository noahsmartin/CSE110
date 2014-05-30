//
//  RestaurantFactory.m
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//


#import "RestaurantFactory.h"
#import "Restaurant.h"
#import "MenyouApi.h"

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
    
    //Double for loop to compare through the array and remove duplicates
    for (int i = 0; i < [list count]; i++)
    {
        //Iterate through the existing list and get one restaurant
        Restaurant* temp = list[i];
        for (int j = i + 1; j < [list count]; j ++)
        {
            //Get another restaurnt
            Restaurant* temp1 = list[j];
            //If the phonenum of the temp is the same as temp1, they're probably the same restaurant
            if ([temp.phoneNumber isEqualToString: temp1.phoneNumber])
            {
                //If temp1 has less reviews remove the duplicate
                if (temp1.numberReviews < temp.numberReviews)
                {
                    [list removeObjectAtIndex:j];
                    j--;
                }
                else //else remove temp
                {
                    [list removeObjectAtIndex:i];
                    i--;
                }
            }
        }
    }
    
    return list;
}

-(NSMutableArray*)restaurantsForData:(NSData *)data withOldList:(NSArray*)previousList
{
    if(!data)
        return nil;
    NSMutableArray* list = [self loadRestaurantsForData:data];
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
    NSMutableArray* ids = [[NSMutableArray alloc] init];
    for(Restaurant* r in list)
    {
        [ids addObject:r.identifier];
    }
    __weak RestaurantFactory* weakSelf = self;
    [[MenyouApi getInstance] getMenusForIds:ids withBlock:^(NSArray *arr) {
        
        int offset = 0;  //used to account for deletion of null objects in array
        for(int i = 0; i < arr.count; i++)
        {
            Menu* m = arr[i];
            if([m isEqual:[NSNull null]]){
                [list removeObjectAtIndex:i-offset];
                offset++;
            }
            else{
                ((Restaurant*) list[i-offset]).menu = m;
            }
        }
        [weakSelf.delegate loadedMenus];
    }];
    return list;
}

@end
