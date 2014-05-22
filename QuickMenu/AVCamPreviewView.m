//
//  AVCamPreviewView.m
//  Menyou
//
//  Created by Noah Martin on 5/21/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "AVCamPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVCamPreviewView

+ (Class)layerClass
{
	return [AVCaptureVideoPreviewLayer class];
}

@end
