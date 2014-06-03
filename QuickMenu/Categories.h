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
@property (nonatomic) NSInteger count;
@property (nonatomic) NSInteger filterCount;
@property NSString* title;
@property NSString* about;
@property NSMutableArray* filteredDishes;

-(instancetype)initWithData:(NSDictionary*)data;

-(void)removeDish:(id)dish;

-(NSArray*)topItems;

-(void)reloadReviews;

-(NSMutableArray*) filterOutDishes:(NSMutableArray*)filters;
@end
