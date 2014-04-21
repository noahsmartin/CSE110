//
//  RestaurantFactory.h
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

/*
 This class is used to parse data from the yelp api
 It is passed the json data from yelp and returns an array of restaurants
 The array is not owned by restaurant factory but by the caller
 The images for the restaurant are loaded by this class and the callback is called when each image is loaded
 */

#import <Foundation/Foundation.h>

@interface RestaurantFactory : NSObject

-(NSMutableArray*)restaurantsForData:(NSData*)data;

@end

@protocol RestaurantFactoryDelegate <NSObject>

@required
-(void)loadedDataForId:(NSString*)id;

@end