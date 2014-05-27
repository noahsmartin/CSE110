//
//  ASMediaFocusManager.h
//  ASMediaFocusManager
//
//  Created by Philippe Converset on 11/12/12.
//  Copyright (c) 2012 AutreSphere. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASMediaFocusManager;

@protocol ASMediasFocusDelegate <NSObject>

// Returns the final focused frame for this media view. This frame is usually a full screen frame.
- (CGRect)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager finalFrameForView:(UIView *)view;
// Returns the view controller in which the focus controller is going to be added. This can be any view controller, full screen or not.
- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager;

-(NSURL*)mediaFocusManager:(ASMediaFocusManager*)mediaFocusManager URLForView:(UIView*)view;

-(UIImage*)mediaFocusManager:(ASMediaFocusManager*)mediaFocusManager defaultImageForView:(UIView*)view;

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view;

@optional
// Called when a focus view is about to be shown. For example, you might use this method to hide the status bar.
- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager;
// Called when a focus view has been shown.
- (void)mediaFocusManagerDidAppear:(ASMediaFocusManager *)mediaFocusManager;
// Called when the view is about to be dismissed by the 'done' button or by gesture. For example, you might use this method to show the status bar (if it was hidden before).
- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager;
// Called when the view has be dismissed by the 'done' button or by gesture.
- (void)mediaFocusManagerDidDisappear:(ASMediaFocusManager *)mediaFocusManager;

@end


@interface ASMediaFocusManager : NSObject

@property (nonatomic, assign) id<ASMediasFocusDelegate> delegate;
// The animation duration. Defaults to 0.5.
@property (nonatomic, assign) NSTimeInterval animationDuration;
// The background color. Defaults to transparent black.
@property (nonatomic, strong) UIColor *backgroundColor;
// Returns whether the animation has an elastic effect. Defaults to YES.
@property (assign, nonatomic) BOOL elasticAnimation;
// Returns whether zoom is enabled on fullscreen image. Defaults to YES.
@property (nonatomic, assign) BOOL zoomEnabled;
// Returns whether gesture is disabled during zooming. Defaults to YES.
@property (nonatomic, assign) BOOL gestureDisabledDuringZooming;
// Returns whether defocuses with tap. Defaults to NO.
@property (nonatomic) BOOL isDefocusingWithTap;

- (void)installOnViews:(NSArray *)views;
- (void)installOnView:(UIView *)view;

@end
