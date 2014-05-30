//
//  OrderViewController.h
//  Menyou
//
//  Created by Edgardo Castro on 5/29/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property NSMutableArray* ordersArray;
@end
