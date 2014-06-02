//
//  MenyouApi.m
//  Menyou
//
//  Created by Noah Martin on 4/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MenyouApi.h"
#import "AFNetworking.h"
#include <CommonCrypto/CommonDigest.h>

@interface MenyouApi() <UIAlertViewDelegate>
@property NSString* session;
@property (nonatomic) NSMutableDictionary* reviews;
@property int wrongPasswordCount;

@end

@implementation MenyouApi

static MenyouApi* instance = nil;
static NSString* baseUrl = @"http://menyouapp.com";

BOOL DEBUG_API = NO;

+(MenyouApi*)getInstance
{
    if(instance == nil)
    {
        return instance = [[MenyouApi alloc] init];
    }
    return instance;
}

-(NSMutableDictionary*)reviews {
    if(!_reviews)
    {
        return _reviews = [[NSMutableDictionary alloc] init];
    }
    return _reviews;
}

-(instancetype)init
{
    if(self = [super init])
    {
        self.session = [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
        _username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        _business = [[NSUserDefaults standardUserDefaults] objectForKey:@"business"];
        self.preferences = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"preferences"]];
        self.dynamicPref = [NSMutableArray arrayWithArray:self.preferences];
        
        if([self loggedIn])
        {
            // This probably isn't necessary but good to have just in case so at least the app does not crash
            // Only needs to be done if logged in, if not the array will be made when the user logs in
            if([self.preferences count] != 6)
            {
                self.preferences = [[NSMutableArray alloc] initWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", nil];
            }
            // Query for the ratings
            NSString* urlString = [NSString stringWithFormat:@"%@/getReviews.php?email=%@&session=%@&timestamp=%f", baseUrl, self.username, self.session, [[NSDate date] timeIntervalSince1970]];
            NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if(!error)
                {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if([[dict objectForKey:@"Status"] isEqualToString:@"Success"])
                    {
                        if([[dict objectForKey:@"Reviews"] isKindOfClass:[NSDictionary class]])
                            self.reviews = [[dict objectForKey:@"Reviews"] mutableCopy];
                    }
                    else
                        [self logout];
                }
            }] resume];
        }
    }
    return self;
}

-(void)getMenuForId:(NSString *)restaurantId withBlock:(void (^)(Menu *))block
{
    NSArray* arr = @[restaurantId];
    [self getMenusForIds:arr withBlock:^(NSArray * newArr) {
        if([newArr count] == 0)
            block(nil);
        else if([NSNull null] == newArr[0])
            block(nil);
        else
        {
            Menu* m = newArr[0];
            block(m);
        }
    }];
}

-(NSArray*)createMenusForData:(NSData*)data
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    if(!data)
        return result;
    if(DEBUG_API)
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for(NSDictionary* d in json)
    {
        // if menu is not found, add a nil object
        if([[d objectForKey:@"Found"] isEqual:[NSNumber numberWithBool:false]]){
            [result addObject:[NSNull null]];
        }
        else{ // else create menu oject and add to result
            Menu* m = [[Menu alloc] initWithData:d];
            [result addObject:m];
        }
    }
    return result;
}

-(void)imageCountForDish:(NSString *)dishid withBlock:(void (^)(int count))block
{
    NSString* urlString = [NSString stringWithFormat:@"%@/getImageCount.php?id=%@&timestamp=%f", baseUrl, dishid, [[NSDate date] timeIntervalSince1970]];
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            block([[dict objectForKey:@"count"] intValue]);
        });
    }] resume];
}

-(void)getMenusForIds:(NSArray*)ids withBlock:(void (^)(NSArray*))block
{
    NSString *urlString = @"http://menyouapp.com/getMenu.php?ids=";
    NSString *idstring = @"";
    for (int i = 0; i < ids.count; i++) {
        if(ids[i] != nil)
            idstring = [idstring stringByAppendingString:ids[i]];
        if(i != ids.count-1)
            idstring = [idstring stringByAppendingString:@","];
    }
    idstring = [self percentEncoding:idstring];
    urlString = [urlString stringByAppendingString:idstring];
    NSURL* URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray* menus = [self createMenusForData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(menus);
        });
    }];
}

-(void)createAccountWithUsername:(NSString*)username Password:(NSString*) password block:(void(^)(BOOL success))block
{
    NSString* passHash = [self percentEncoding:[self sha256:password]];
    NSString* urlString = [NSString stringWithFormat:@"%@/appCreateAccount.php?email=%@&passhash=%@", baseUrl, [self percentEncoding:username], passHash];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [request setHTTPMethod:@"GET"];
    [self processAccountRequest:request username:username block:block];
}

-(void)logInWithUsername:(NSString *)username Password:(NSString *)password block:(void (^)(BOOL))block
{
    NSString* passHash = [self percentEncoding:[self sha256:password]];
    NSString* urlString = [NSString stringWithFormat:@"%@/appLogin.php?email=%@&passhash=%@", baseUrl, [self percentEncoding:username], passHash];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [request setHTTPMethod:@"GET"];
    [self processAccountRequest:request username:username block:block];
}

-(int)getReviewFor:(NSString *)dishid
{
    if([self.reviews objectForKey:dishid])
    {
        return [[self.reviews objectForKey:dishid] intValue];
    }
    return -1;
}

-(void)processAccountRequest:(NSURLRequest*)request username:(NSString*)username block:(void (^)(BOOL))block
{
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data)
        {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if(DEBUG_API)
                NSLog(@"%@", json);
            if([[json objectForKey:@"Status"] isEqualToString:@"Success"])
            {
                // As soon as you are logged in successfully, clear the wrong password count
                self.wrongPasswordCount = 0;
                _username = username;
                self.session = [json objectForKey:@"SessionID"];
                _business = [json objectForKey:@"Business"];
                if(!self.preferences)
                    self.preferences = [NSMutableArray array];
                [self.preferences addObject:[NSString stringWithFormat:@"%@", [json objectForKey:@"Vegetarian"]]];
                [self.preferences addObject:[NSString stringWithFormat:@"%@", [json objectForKey:@"Vegan"]]];
                [self.preferences addObject:[NSString stringWithFormat:@"%@", [json objectForKey:@"Dairy-Free"]]];
                [self.preferences addObject:[NSString stringWithFormat:@"%@", [json objectForKey:@"Peanut-Allergy"]]];
                [self.preferences addObject:[NSString stringWithFormat:@"%@", [json objectForKey:@"Kosher"]]];
                [self.preferences addObject:[NSString stringWithFormat:@"%@", [json objectForKey:@"Low-Fat"]]];
                
                self.dynamicPref = [NSMutableArray arrayWithArray:self.preferences];
                
                if([[json objectForKey:@"Reviews"] isKindOfClass:[NSDictionary class]])
                    self.reviews = [[json objectForKey:@"Reviews"] mutableCopy];
                [[NSUserDefaults standardUserDefaults] setObject:self.session forKey:@"session"];
                [[NSUserDefaults standardUserDefaults] setObject:self.business forKey:@"business"];
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:self.preferences forKey:@"preferences"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.delegate loginStatusChagned];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            }
            else
            {
                // Only increment the wrong password count for login
                if([[request.URL absoluteString] rangeOfString:@"appLogin"].location != NSNotFound)
                {
                    self.wrongPasswordCount++;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.wrongPasswordCount < 3)
                    {
                        UIAlertView *errorAlert = [[UIAlertView alloc]
                                                   initWithTitle:@"Error" message:[json objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [errorAlert show];
                    }
                    else
                    {
                        [self sendForgottenPassword:username];
                        self.wrongPasswordCount = 0;
                    }
                    block(NO);
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO);
            });
        }
    }];
}

-(void)sendForgottenPassword:(NSString*)username{
    UIAlertView *sendPassAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Forgot your password?" message:@"Enter your e-mail address and a link will be sent to you to reset your password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [sendPassAlert addButtonWithTitle:@"Cancel"];
    sendPassAlert.tag = 100;
    sendPassAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [sendPassAlert textFieldAtIndex:0].text = username;
    [sendPassAlert textFieldAtIndex:0].keyboardType = UIKeyboardTypeEmailAddress;
    [sendPassAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0 && alertView.tag == 100){
        NSString* email = [self percentEncoding:[alertView textFieldAtIndex:0].text];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://menyouapp.com/recoverPassword.php?email=%@", email]];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(!connectionError)
            {
                /*UIAlertView *sentAlert = [[UIAlertView alloc] init];
                [sentAlert setDelegate:self];
                [sentAlert setMessage:@"Your password reset request has been sent to your e-mail"];
                [sentAlert addButtonWithTitle:@"Ok"];
                [sentAlert show];*/
            }
        }];
    }
}

-(void)logout
{
    _username = nil;
    self.session = nil;
    _business = nil;
    self.reviews = nil;
    _preferences = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"business"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"preferences"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.delegate loginStatusChagned];
}

-(BOOL)loggedIn
{
    if(self.session)
        return YES;
    return NO;
}

-(void)addReview:(int)rating item:(NSString*)item withImage:(UIImage*)image withBlock:(void(^)(BOOL success))block;
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    NSData *imageData = nil;
    if(image)
        imageData = UIImageJPEGRepresentation(image, 0.5);
    NSDictionary *parameters = @{@"email": self.username, @"session" : self.session, @"rating":[NSString stringWithFormat:@"%d",rating], @"item":item};
    AFHTTPRequestOperation *op = [manager POST:@"addRating.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image)
            [formData appendPartWithFileData:imageData name:@"file" fileName:[NSString stringWithFormat:@"%@.jpg", self.username] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([[responseObject objectForKey:@"Status"] isEqualToString:@"Failure"])
            block(NO);
        else
        {
            [self.reviews setObject:[NSNumber numberWithInt:rating] forKey:item];
            block(YES);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO);
    }];
    [op start];
}

-(void)setPref:(NSString *)pref withValue:(int)value withBlock:(void (^)(BOOL))block
{
    NSString* urlString = [NSString stringWithFormat:@"%@/setPref.php?username=%@&sessionid=%@&pref=%@&value=%d&timestamp=%f", baseUrl, self.username, self.session, pref, value, [[NSDate date] timeIntervalSince1970]];
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if([[dict objectForKey:@"Status"] isEqualToString:@"Success"])
            {
                block(YES);
            }
            else
                block(NO);
        }
        block(NO);
    }] resume];
}

-(NSString*)percentEncoding:(NSString*)input
{
    NSMutableString *newString = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[input UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
            (thisChar >= 'a' && thisChar <= 'z') ||
            (thisChar >= 'A' && thisChar <= 'Z') ||
            (thisChar >= '0' && thisChar <= '9')) {
            [newString appendFormat:@"%c", thisChar];
        } else {
            [newString appendFormat:@"%%%02X", thisChar];
        }
    }
    return newString;
}

-(void)savePrefs
{
    [[NSUserDefaults standardUserDefaults] setObject:self.preferences forKey:@"preferences"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*) sha256:(NSString *)string{
    const char *s=[string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, (unsigned int) keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

-(void)filterUpdated
{
    NSLog(@"hi");
    NSLog(@"%@", self.filterDelegate);
    [self.filterDelegate dynamicFilterChanged];
}

@end
