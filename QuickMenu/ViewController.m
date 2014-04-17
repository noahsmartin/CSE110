//
//  ViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/14/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UILabel *logo;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *creatAccountButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmText;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translate"];
    scaleAnimation.duration = 0.2;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0.9];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    /*[UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundImage.frame  = CGRectMake(0, 0, 320,30);
    } completion:^(BOOL finished) {
        
    }];*/
    /*CGRect frame = self.backgroundImage.frame;
    frame.size.height += 100;
    self.backgroundImage.frame = frame;
    //[self.backgroundImage setNeedsDisplay];
    CGPoint center = self.backgroundImage.center;
    center.y += 100;
    self.backgroundImage.center = center;
    [self.backgroundImage setNeedsDisplay];*/
    
    //self.loginButton.frame = CGRectMake(0, 0, 200, 200);

    //[self.view setNeedsDisplay];
    
    
    self.backgroundImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundImage.layer.shadowOpacity = 0.38;
    self.backgroundImage.layer.shadowRadius = 5;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 6);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

- (IBAction)createAccount:(id)sender {
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
     self.backgroundImage.frame  = CGRectMake(0, -240, self.backgroundImage.frame.size.width,self.backgroundImage.frame.size.height);
     } completion:^(BOOL finished) {
     }];
}

- (IBAction)continue:(id)sender {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.logo, self.lineView]];
    gravityBehavior.magnitude = 8;
    UIGravityBehavior *gravity2 = [[UIGravityBehavior alloc] initWithItems:@[self.loginButton, self.continueButton, self.createAccountButton]];
    [self.animator addBehavior:gravity2];
    [self.animator addBehavior:gravityBehavior];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   // your choice here from UIModalTransitionStyle
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
