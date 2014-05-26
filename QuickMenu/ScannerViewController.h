//
//  ScannerViewController.h
//  Menyou
//
//  Created by Edgardo Castro on 5/25/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "LeftTableViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ScannerViewController : UIViewController <ECSlidingViewControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>
@property UIViewController* homeViewController;
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *bbitemStart;
- (IBAction)startStopReading:(id)sender;

@end
