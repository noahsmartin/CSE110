//
//  Menu.h
//  Menyou
//
//  Created by Noah Martin on 4/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (strong, nonatomic) NSArray* categories;  // This is the menu, an array of categories


// so still need to implement Dish class, and Category
// categories , like breakfast, lunch , dinner etc
//

@property (nonatomic) int numberSelected;

-(void)pickRandomItems;

-(instancetype)initWithData:(NSDictionary*)data;

@end
