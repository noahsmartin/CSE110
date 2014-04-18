//
//  MenyouApi.h
//  Menyou
//
//  Created by Noah Martin on 4/17/14.
//  Copyright (c) 2014 Noah Martin. All rights reserved.
//

/*
 This singleton class interfaces with the MenyouAPI
 Clients can register to recieve callbacks when updates are performed
 */


#import <Foundation/Foundation.h>

@interface MenyouApi : NSObject

@property (readonly) NSString* username;

// This is an array of restaurants
@property (readonly) NSArray* restarants;

// This is a singleton class
// Populates defaults in restaruants until requestInfo called
+(MenyouApi*)getInstance;

// Create an account and have the user logged in
-(void)createAccountWithUsername:(NSString*)username Password:(NSString*) password block:(void(^)(BOOL success))block;

// Log in a user
-(void)LogInWithUsername:(NSString*)username Password:(NSString*) password block:(void(^)(BOOL success))block;

// Log out a user - this should return instantly
-(void)logout;

// Request info about restaurants given list of ids from yelp
// First callback is executed when it is determined which restaruants are available
-(void)requestInfo:(NSArray*)restuarantIds;

@end
