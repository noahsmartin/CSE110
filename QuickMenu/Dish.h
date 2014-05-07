//
//  Dishes.h
//  Menyou
//
//  Created by Edgardo Castro on 5/1/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dish : NSObject

@property BOOL isSelected;

@property NSString* title;
@property NSString* price;
@property NSString* itemDescription;

-(instancetype)initWithData:(NSDictionary*)data;

@end
