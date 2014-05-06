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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //disabling the three textfields so keyboard doesn't show up when not supposed to
    _usernameText.enabled = NO;
    _passwordText.enabled = NO;
    _passwordConfirmText.enabled = NO;
    
    //disabling the create button associated with the textfields
    _createAccountButton.enabled = NO;
    
    self.usernameText.placeholder = @"Email";
    self.backgroundImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundImage.layer.shadowOpacity = 0.38;
    self.backgroundImage.layer.shadowRadius = 4;
    self.backgroundImage.layer.shadowOffset = CGSizeMake(0, 5);
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
        // Call api here
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

- (IBAction)createAccount:(id)sender {
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         self.backgroundImage.frame  = CGRectMake(0, -240, self.backgroundImage.frame.size.width,self.backgroundImage.frame.size.height);
         self.logoView.frame = CGRectMake(self.logoView.frame.origin.x, self.logoView.frame.origin.y - 240, self.logoView.frame.size.width, self.logoView.frame.size.height);
        
     } completion:^(BOOL finished) {
     }];
    
    //enabling the three textfields for user input
    _usernameText.enabled = YES;
    _passwordText.enabled = YES;
    _passwordConfirmText.enabled = YES;
    
    //enabling the create button associated with the textfields
    _createAccountButton.enabled = YES;
    
    [sender setEnabled:NO];
}


- (IBAction)continue:(id)sender {
    [self continueHome];
}

-(void)continueHome {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"firstOpening"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.logoView]];
    gravityBehavior.magnitude = 8;
    UIGravityBehavior *gravity2 = [[UIGravityBehavior alloc] initWithItems:@[self.loginButton, self.continueButton, self.createAccountButton]];
    [self.animator addBehavior:gravity2];
    [self.animator addBehavior:gravityBehavior];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   // your choice here from UIModalTransitionStyle
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
