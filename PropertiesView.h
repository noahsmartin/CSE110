//
//  PropertiesView.h
//  Menyou
//
//  Created by Joanne T Wu on 6/3/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertiesView : UIView

@property (nonatomic) NSArray* dishProps;
@property NSString* chefRecommended;

-(void)setAttributeImages:(NSArray*)dishProps;

@end
