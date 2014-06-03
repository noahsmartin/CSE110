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
@property AVCaptureDevice *captureDevice;
@property  AVCaptureDeviceInput *input;
@property AVCaptureMetadataOutput *captureMetadataOutput;

-(void)startReading;
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
    
    NSError *error;
    
    _isReading = NO;
    _captureSession = [[AVCaptureSession alloc] init];
    _orderCount = 0;
    _orders = [[NSMutableArray alloc]init];
    _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_captureDevice error:&error];
    _captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    if (!_input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [_captureSession addInput:_input];

    
    self.dynamicTransition = [[MEDynamicTransition alloc] init];
    self.dynamicTransition.slidingViewController = self.slidingViewController;
    self.slidingViewController.delegate = self.dynamicTransition;
    
    self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.slidingViewController.delegate action:@selector(handlePanGesture:)];
    
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
    self.slidingViewController.customAnchoredGestures = @[self.dynamicTransitionPanGesture];
    [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_lblStatus setText:@"Number of Orders: 0"];
    
    [self startReading];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStopReading:(id)sender  // scan button
{
    [self startReading];

}

- (void)startReading {

    [_captureSession addOutput:_captureMetadataOutput];
    _bbitemStart.enabled = NO;
    [_bbitemStart setTitle:@"Scanning..." forState:UIControlStateNormal];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [_captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [_captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    [_captureSession startRunning];
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

    _bbitemStart.enabled = YES;
    [_bbitemStart setTitle:@"Scan Orders" forState:UIControlStateNormal];
    [_captureSession removeOutput:_captureMetadataOutput];
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
