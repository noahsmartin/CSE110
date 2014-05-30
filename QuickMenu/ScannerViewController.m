//
//  ScannerViewController.m
//  Menyou
//
//  Created by Edgardo Castro on 5/25/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "ScannerViewController.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenyouApi.h"
#import "OrderViewController.h"

@interface ScannerViewController ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property MEDynamicTransition* dynamicTransition;
@property (weak, nonatomic) IBOutlet UILabel *usernameView;

@property int orderCount;
@property (nonatomic) NSMutableArray* orders;
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


-(BOOL)startReading;
-(void)stopReading;



@end

@implementation ScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isReading = NO;
    _captureSession = nil;
    _orderCount = 0;
    _orders = [[NSMutableArray alloc]init];
    
    self.dynamicTransition = [[MEDynamicTransition alloc] init];
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.delegate = self.dynamicTransition;
    
    self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.slidingViewController.delegate action:@selector(handlePanGesture:)];
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    if ([self startReading]) {
        NSString *s = @"Number of orders: ";
        NSString *number = [s stringByAppendingString:[NSString stringWithFormat:@"%d",_orderCount]] ;
        [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:number waitUntilDone:NO];
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopReading:(id)sender
{
        if ([self startReading]) {
            NSString *s = @"Number of orders: ";
            NSString *number = [s stringByAppendingString:[NSString stringWithFormat:@"%d",_orderCount]] ;
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:number waitUntilDone:NO];
        }

}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Scan for Orders" waitUntilDone:NO];
            
            // create JSON array from result of QR scan, add it to array of orders
            NSData *data = [[metadataObj stringValue] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            [_orders addObject:json];
            _orderCount++;
            
            // update the number of orders displayed on the screen
            NSString *s = @"Number of orders: ";
            NSString *number = [s stringByAppendingString:[NSString stringWithFormat:@"%d",_orderCount]] ;
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:number waitUntilDone:NO];
            
            
    }
        
        
    }
    
}


-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showScanOrder"]) {
        OrderViewController *destViewController = segue.destinationViewController;
        destViewController.ordersArray = self.orders;
    }
    
    
}


@end
