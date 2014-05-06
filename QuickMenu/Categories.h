//
//  Category.h
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dish.h"

@interface Categories : NSObject

@property NSArray* dishes;
@property NSString* title;
@property NSString* about;

-(instancetype)initWithData:(NSDictionary*)data;

@end