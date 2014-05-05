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
    NSString *urlString = @"http://noahmart.in/menyou.php?ids=";
    urlString = [urlString stringByAppendingString:restaurantId];
    NSURL* URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary* json = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] objectAtIndex:0];
        Menu* m = [[Menu alloc] initWithData:json];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(m);
        });
    }];
}

@end
