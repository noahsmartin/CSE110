//
//  DishTableViewCell.h
//  Menyou
//
//  Created by Noah Martin on 5/6/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "PropertiesView.h"

@protocol DishTableViewDelegate <NSObject>

@required
-(BOOL)canRemove:(id)cell;
-(void)itemSelected:(id)cell;

// Must be implemented if canRemove returns YES
@optional
-(void)itemRemoved:(id)cell;

@end

@interface DishTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) id<DishTableViewDelegate> delegate;
@property (weak) id data;  // The dish object, the view should not know anything about it
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet PropertiesView *propView;

-(void)setDishSelected:(BOOL)selected;
-(void)setColor:(UIColor*)color;
-(void)setimageAttributes:(NSArray*)dishProps;
-(void)setChefRecommended:(NSString*)setChef;

@end
