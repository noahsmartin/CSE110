//
//  MenyouApi.m
//  Menyou
//
//  Created by Noah Martin on 4/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

#import "MenyouApi.h"

@implementation MenyouApi

static MenyouApi* instance = nil;

BOOL DEBUG_API = NO;

+(MenyouApi*)getInstance
{
    if(instance == nil)
    {
        return instance = [[MenyouApi alloc] init];
    }
    return instance;
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
        // TODO: check if the menu is found, add nil if it is not
        Menu* m = [[Menu alloc] initWithData:d];
        [result addObject:m];
    }
    return result;
}

-(void)getMenusForIds:(NSArray*)ids withBlock:(void (^)(NSArray*))block
{
    NSString *urlString = @"http://www.quickresapp.com/menyouApi.php?ids=test";
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

@end
