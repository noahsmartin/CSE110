//
//  MenyouApi.m
//  Menyou
//
//  Created by Noah Martin on 4/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MenyouApi.h"
#include <CommonCrypto/CommonDigest.h>

@interface MenyouApi()
@property NSString* session;

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

-(instancetype)init
{
    if(self = [super init])
    {
        self.session = [[NSUserDefaults standardUserDefaults] objectForKey:@"session"];
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
        if([[d objectForKey:@"found"] isEqual:[NSNumber numberWithBool:false]]){
            [result addObject:[NSNull null]];
        }
        else{ // else create menu oject and add to result
            Menu* m = [[Menu alloc] initWithData:d];
            [result addObject:m];
        }
    }
    return result;
}

-(void)getMenusForIds:(NSArray*)ids withBlock:(void (^)(NSArray*))block
{
    NSString *urlString = @"http://www.quickresapp.com/menyouApi.php?ids=";
    for (int i = 0; i < ids.count; i++) {
        urlString = [urlString stringByAppendingString:ids[i]];
        if(i != ids.count-1)
            urlString = [urlString stringByAppendingString:@","];
    }
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
    NSString* urlString = [NSString stringWithFormat:@"%@/appCreateAccount.php?email=%@&passhash=%@", baseUrl, username, [self sha256:password]];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [request setHTTPMethod:@"GET"];
    [self processAccountRequest:request username:username block:block];
}

-(void)logInWithUsername:(NSString *)username Password:(NSString *)password block:(void (^)(BOOL))block
{
    NSString* urlString = [NSString stringWithFormat:@"%@/appLogin.php?email=%@&passhash=%@", baseUrl, username, [self sha256:password]];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [request setHTTPMethod:@"GET"];
    [self processAccountRequest:request username:username block:block];
}

-(void)processAccountRequest:(NSURLRequest*)request username:(NSString*)username block:(void (^)(BOOL))block
{
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data)
        {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if([[json objectForKey:@"Status"] isEqualToString:@"Success"])
            {
                _username = username;
                self.session = [json objectForKey:@"SessionID"];
                [[NSUserDefaults standardUserDefaults] setObject:self.session forKey:@"session"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *errorAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Error" message:[json objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [errorAlert show];
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

-(void)logout
{
    _username = nil;
    self.session = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"session"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)loggedIn
{
    if(self.session)
        return YES;
    return NO;
}

-(void)addReview:(int)rating forRestaurant:(NSString *)restaurant item:(NSString *)item withBlock:(void (^)(BOOL))block
{
    // Just a fake api call to get a little delay
    NSString* urlString = [NSString stringWithFormat:@"%@/appLogin.php", baseUrl];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:8.0];
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(YES);
        });
    }];
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

@end
