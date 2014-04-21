//
//  Restaurant.h
//  Menyou
//
//  Created by Noah Martin on 4/18/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property NSString* identifier;
@property NSString* title;
@property NSString* description;
@property UIImage* image;

-(instancetype)initWithData:(NSDictionary*)data;

@end
