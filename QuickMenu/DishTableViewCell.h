//
//  DishTableViewCell.h
//  Menyou
//
//  Created by Noah Martin on 5/6/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@protocol DishTableViewDelegate <NSObject>

@required
-(void)itemRemoved:(id)cell;
-(void)itemSelected:(id)cell;

@end

@interface DishTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) id<DishTableViewDelegate> delegate;
@property (weak) id data;  // The dish object, the view should not know anything about it
@property (weak, nonatomic) IBOutlet StarView *starView;

-(void)setDishSelected:(BOOL)selected;
-(void)setColor:(UIColor*)color;

@end
