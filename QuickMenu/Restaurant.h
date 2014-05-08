//
//  Restaurant.h
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Menu.h"

@interface Restaurant : NSObject

@property NSString* identifier;
@property NSString* title;
@property UIImage* image;
@property double rating;
@property double distance;
@property int numberReviews;
@property int phoneNumber;
@property NSString* imageUrl;
@property NSString* location;
@property Menu* menu;

-(instancetype)initWithData:(NSDictionary*)data;

@end
