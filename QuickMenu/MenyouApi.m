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
    NSLog(@"get for id");
    NSArray* arr = @[restaurantId];
    [self getMenusForIds:arr withBlock:^(NSArray * newArr) {
        Menu* m = newArr[0];
        block(m);
    }];
}

-(NSArray*)createMenusForData:(NSData*)data
{
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableArray* result = [[NSMutableArray alloc] init];
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
    NSString *urlString = @"http://noahmart.in/menyou.php?ids=";
    for (int i = 0; i < ids.count; i++) {
        urlString = [urlString stringByAppendingString:ids[i]];
        if(i != ids.count-1)
            urlString = [urlString stringByAppendingString:@","];
    }
    NSURL* URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray* menus = [self createMenusForData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(menus);
        });
    }];
}

@end
