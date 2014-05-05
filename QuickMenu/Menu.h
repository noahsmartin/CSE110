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

@property (nonatomic) int numberSelected;
@property (nonatomic) int numCategories;

-(void)pickRandomItems;

-(instancetype)initWithData:(NSDictionary*)data;

@end
