//
//  ViewController.m
//  QuickMenu
//
//  Created by Noah Martin on 4/14/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "MenyouApi.h"

@interface ViewController ()
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *creatAccountButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmText;
@property (weak, nonatomic) IBOutlet UIButton *logginButton;
@property (nonatomic) BOOL buttonClicked;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //disabling the three textfields so keyboard doesn't show up when not supposed to
    self.usernameText.hidden = YES;
    self.passwordText.hidden = YES;
    self.passwordConfirmText.hidden = YES;
    
    //disabling the create button associated with the textfields
    self.creatAccountButton.hidden = YES;
    self.logginButton.hidden = YES;
    
    self.usernameText.placeholder = @"Email";
    self.backgroundImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundImage.layer.shadowOpacity = 0.38;
    self.backgroundImage.layer.shadowRadius = 4;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
    
    self.buttonClicked = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)createAccountButton:(id)sender {
    if([self.passwordText.text isEqualToString:self.passwordConfirmText.text] == NO){
        self.passwordText.text = nil;
        self.passwordConfirmText.text = nil;
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else if([self.passwordText.text isEqualToString:@""] || [self.passwordConfirmText.text isEqualToString:@""]
        || [self.usernameText.text isEqualToString:@""])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"All fields must be filled out" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else if([self validateEmail:self.usernameText.text])
    {
      // call api
        
        [[MenyouApi getInstance] createAccountWithUsername:[self.usernameText text] Password:[self.passwordText text] block:^(BOOL success) {
            if(success)
                [self dismissViewControllerAnimated:YES completion:^{}];
        }];
        
    }
}

-(BOOL)validateEmail:(NSString*) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL b = [emailTest evaluateWithObject:email];
    if(!b)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Invalid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    return b;
}

-(IBAction) login:(id)sender{
    
    if(_buttonClicked == FALSE){
      [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundImage.frame  = CGRectMake(0, -240, self.backgroundImage.frame.size.width,self.backgroundImage.frame.size.height);
        self.logoView.frame = CGRectMake(self.logoView.frame.origin.x, self.logoView.frame.origin.y - 240, self.logoView.frame.size.width, self.logoView.frame.size.height);
        
       } completion:^(BOOL finished) {
      }];
        _buttonClicked = TRUE;
    }
    
    //enabling the three textfields for user input
    self.usernameText.hidden = NO;
    self.passwordText.hidden = NO;
    self.usernameText.text = @"";
    self.passwordText.text = @"";
    
    //enabling the create button associated with the textfields
    self.logginButton.hidden = NO;
    
    //hiding create stuff
    self.creatAccountButton.hidden = YES;
    self.passwordConfirmText.hidden = YES;
}

-(IBAction)confirmLogin:(id)sender{
    if([self.passwordText.text isEqualToString:@""] || [self.usernameText.text isEqualToString:@""])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"All fields must be filled out" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else if([self validateEmail:self.usernameText.text])
    {
        [[MenyouApi getInstance] logInWithUsername:self.usernameText.text Password:self.passwordText.text block:^(BOOL success) {
            if(success)
                [self dismissViewControllerAnimated:YES completion:^{}];
        }];
    }
}


- (IBAction)createAccount:(id)sender {
    
    if(!self.buttonClicked){
       [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         self.backgroundImage.frame  = CGRectMake(0, -240, self.backgroundImage.frame.size.width,self.backgroundImage.frame.size.height);
         self.logoView.frame = CGRectMake(self.logoView.frame.origin.x, self.logoView.frame.origin.y - 240, self.logoView.frame.size.width, self.logoView.frame.size.height);
        
       } completion:^(BOOL finished) {
       }];
        self.buttonClicked = YES;
    }
    
    //enabling the create button associated with the textfields
    self.creatAccountButton.hidden = NO;
    self.usernameText.hidden = NO;
    self.passwordText.hidden = NO;
    self.passwordConfirmText.hidden = NO;
    self.usernameText.text = @"";
    self.passwordText.text = @"";
    self.passwordConfirmText.text = @"";
    
    //hiding stuff
    self.logginButton.hidden = YES;
}


- (IBAction)continue:(id)sender {
    [self continueHome];
}

-(void)continueHome {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstOpening"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.logoView, self.backgroundImage]];
    gravityBehavior.magnitude = 8;
    UIGravityBehavior *gravity2 = [[UIGravityBehavior alloc] initWithItems:@[self.loginButton, self.continueButton, self.createAccountButton]];
    [self.animator addBehavior:gravity2];
    [self.animator addBehavior:gravityBehavior];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   // your choice here from UIModalTransitionStyle
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
