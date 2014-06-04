//
//  LoginViewController.m
//  Menyou
//
//  Created by Noah Martin on 5/12/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "LoginViewController.h"
#import "MenyouApi.h"

#if __has_include(<LocalAuthentication/LocalAuthentication.h>)
#import <LocalAuthentication/LocalAuthentication.h>
#endif

#if __has_include(<CloudKit/CloudKit.h>)
#import <CloudKit/CloudKit.h>
#endif

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *createAccountEmailText;
@property (weak, nonatomic) IBOutlet UITextField *createAccountPasswordText;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmText;
@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 299, 320, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [[self view] addSubview:lineView];
}

- (IBAction)touchId:(id)sender {
    // Check for pre ios8
#if !TARGET_IPHONE_SIMULATOR
    if(NSClassFromString(@"LAContext") != Nil)
    {
        LAContext *myContext = [[LAContext alloc] init];
        NSError *authError = nil;
        NSString *myLocalizedReasonString = @"Authenticate with TouchID to log in.";
        
        if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:myLocalizedReasonString
                                reply:^(BOOL succes, NSError *error) {
                                    if (succes) {
                                        CKFetchRecordsOperation* operation = [CKFetchRecordsOperation fetchCurrentUserRecordOperation];
                                        operation.perRecordProgressBlock = ^(CKRecordID *recordID, double progress)
                                        {
                                            
                                        };
                                        operation.perRecordCompletionBlock = ^(CKRecord *record, CKRecordID *recordID, NSError* error) {
                                            if(recordID)
                                            {
                                                [[MenyouApi getInstance] scannerLogInWithUsername:[recordID.recordName stringByAppendingString:@"@menyoutouch.com"] Password:@"auth" block:^(BOOL success) {
                                                    [self dismissViewControllerAnimated:YES completion:^{}];
                                                }];
                                            }
                                            else
                                            {
                                                UIAlertView *errorAlerr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not authenticate, please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                [errorAlerr show];
                                            }
                                        };
                                        [operation start];
                                    } else {
                                        NSLog(@"fail");
                                        // User did not authenticate successfully, look at error and take appropriate action
                                    }
                                }];
        } else {
            // Could not evaluate policy; look at authError and present an appropriate message to user
        }
    }
    else {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"TouchID authentication not supported on your device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
#endif
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)login:(id)sender {
    if([self.passwordText.text isEqualToString:@""] || [self.emailText.text isEqualToString:@""])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"All fields must be filled out" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else if([self validateEmail:self.emailText.text])
    {
        [[MenyouApi getInstance] logInWithUsername:self.emailText.text Password:self.passwordText.text block:^(BOOL success) {
            if(success)
                [self dismissViewControllerAnimated:YES completion:^{}];
        }];
    }
}

- (IBAction)createAccount:(id)sender {
    
    if([self.createAccountPasswordText.text isEqualToString:self.passwordConfirmText.text] == NO){
        self.createAccountPasswordText.text = nil;
        self.passwordConfirmText.text = nil;
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Passwords don't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else if([self.createAccountPasswordText.text isEqualToString:@""] || [self.passwordConfirmText.text isEqualToString:@""]
            || [self.createAccountEmailText.text isEqualToString:@""])
    {
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"All fields must be filled out" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
    }
    else if([self validateEmail:self.createAccountEmailText.text])
    {
        [[MenyouApi getInstance] createAccountWithUsername:[self.createAccountEmailText text] Password:[self.createAccountPasswordText text] block:^(BOOL success) {
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

- (IBAction)emailPressed:(id)sender {
    if (self.view.frame.origin.y != 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.44];
    self.view.frame = CGRectMake(0, -216, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (IBAction)editingEnded:(id)sender {

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    if (self.view.frame.origin.y == 0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.24];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.emailText)
    {
        [self.passwordText becomeFirstResponder];
    }
    else if(textField == self.passwordText)
    {
        [self login:nil];
    }
    else if(textField == self.createAccountEmailText)
    {
        [self.createAccountPasswordText becomeFirstResponder];
    }
    else if(textField == self.createAccountPasswordText)
    {
        [self.passwordConfirmText becomeFirstResponder];
    }
    else if(textField == self.passwordConfirmText)
    {
        [self createAccount:nil];
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.24];
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    return YES;
}

@end
