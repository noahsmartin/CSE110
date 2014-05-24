//
//  AddRatingViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "AddRatingViewController.h"
#import "StarView.h"
#import "MenyouApi.h"
#import <AVFoundation/AVFoundation.h>

static void * CapturingStillImageContext = &CapturingStillImageContext;
@interface AddRatingViewController()
@property (weak, nonatomic) IBOutlet StarView *rating;
@property (weak, nonatomic) IBOutlet UILabel *description;
@property int myRating;
@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;
@property UIActivityIndicatorView *activityIndicator;
@property AVCaptureSession *session;
@property (weak, nonatomic) IBOutlet UIView *videoLayer;
@property dispatch_queue_t sessionQueue;
@property AVCaptureStillImageOutput *stillImageOutput;
@property AVCaptureDeviceInput *videoDeviceInput;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation AddRatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (IBAction)cancel:(id)sender {
    if(self.myRating > 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to cancel your review?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"Continue reviewing", nil] show];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (IBAction)save:(id)sender {
    [[MenyouApi getInstance] addReview:self.myRating item:[NSString stringWithFormat:@"%d", self.dish.identifier] withImage:self.imageView.image withBlock:^(BOOL success) {
        [self.activityIndicator stopAnimating];
        if(success)
        {
            self.dish.myRating = self.myRating;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not post review" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
    [self.activityIndicator startAnimating];
}

- (IBAction)oneStar:(id)sender {
    self.myRating = 1;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
}

- (IBAction)twoStars:(id)sender {
    self.myRating = 2;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
}

- (IBAction)threeStars:(id)sender {
    self.myRating = 3;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
}

- (IBAction)fourStars:(id)sender {
    self.myRating = 4;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starEmptyLarge"] forState:UIControlStateNormal];
}

- (IBAction)fiveStars:(id)sender {
    self.myRating = 5;
    [self.starOne setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starTwo setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starThree setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starFour setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
    [self.starFive setBackgroundImage:[UIImage imageNamed:@"starFullLarge"] forState:UIControlStateNormal];
}
- (IBAction)takePicture:(id)sender {
    dispatch_async([self sessionQueue], ^{
		
        if ([self.videoDeviceInput.device hasFlash] && [self.videoDeviceInput.device isFlashModeSupported:AVCaptureFlashModeAuto])
        {
            NSError *error = nil;
            if ([self.videoDeviceInput.device lockForConfiguration:&error])
            {
                [self.videoDeviceInput.device setFlashMode:AVCaptureFlashModeAuto];
                [self.videoDeviceInput.device unlockForConfiguration];
            }
            else
            {
                NSLog(@"%@", error);
            }
        }
        
        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self videoLayer] layer] connection] videoOrientation]];
		
		// Capture a still image.
		[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
			
			if (imageDataSampleBuffer)
			{
				NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                [self.imageView setHidden:NO];
                self.imageView.image = [self cropImage:image];
			}
		}];
	});
}

- (UIImage *)cropImage:(UIImage *)oldImage {
    CGSize imageSize = oldImage.size;
    double ratio = imageSize.width / self.imageView.frame.size.width;
    UIGraphicsBeginImageContextWithOptions( CGSizeMake( self.imageView.frame.size.width * ratio,
                                                       self.imageView.frame.size.height * ratio),
                                           NO,
                                           0.);
    [oldImage drawAtPoint:CGPointMake( 0, 0)
                blendMode:kCGBlendModeCopy
                    alpha:1.];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = nil;
    [self.imageView setHidden:YES];
    self.rating.rating = self.dish.rating;
    self.rating.numberReviews = self.dish.numRatings;
    self.description.text = self.dish.itemDescription;
    self.myRating = 0;
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.color = [UIColor blackColor];
    self.activityIndicator.center = self.view.center;
    [self.view addSubview:self.activityIndicator];
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    [self setSession:session];
    [(AVCaptureVideoPreviewLayer*) [self.videoLayer layer] setSession:session];
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
	dispatch_async(self.sessionQueue, ^{
        AVCaptureDevice *videoDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] firstObject];
        NSError *error;
		AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        if(error)
        {
            NSLog(@"%@", error);
        }
        if ([session canAddInput:videoDeviceInput])
		{
			[session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
            
			dispatch_async(dispatch_get_main_queue(), ^{
                CGRect rect = CGRectMake(0, 450, 320, 215);
                [(AVCaptureVideoPreviewLayer *) [self.videoLayer layer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
                [[self.videoLayer layer] setFrame:rect];
			});
		}
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
		if ([session canAddOutput:stillImageOutput])
		{
			[stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
			[session addOutput:stillImageOutput];
			[self setStillImageOutput:stillImageOutput];
		}
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(context == CapturingStillImageContext)
    {
		BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        if(isCapturingStillImage)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[self videoLayer] layer] setOpacity:0.0];
                [UIView animateWithDuration:.25 animations:^{
                    [[[self videoLayer] layer] setOpacity:1.0];
                }];
            });
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_async(self.sessionQueue, ^{
        [self addObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:CapturingStillImageContext];
		[[self session] startRunning];
    });
}

-(void)viewDidDisappear:(BOOL)animated
{
    dispatch_async(self.sessionQueue, ^{
        [[self session] stopRunning];
        [self removeObserver:self forKeyPath:@"stillImageOutput.capturingStillImage" context:CapturingStillImageContext];
    });
}

@end
