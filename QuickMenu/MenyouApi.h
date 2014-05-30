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
#import "Menu.h"

@protocol MenyouApiDelegate

@required
-(void)loginStatusChagned;

@end

@interface MenyouApi : NSObject

@property (readonly) NSString* username;

@property (readonly) NSString* business;

@property NSMutableArray* preferences;

@property (weak) id<MenyouApiDelegate> delegate;

// This is a singleton class
// Populates defaults in restaruants until requestInfo called
+(MenyouApi*)getInstance;

// Create an account and have the user logged in
-(void)createAccountWithUsername:(NSString*)username Password:(NSString*) password block:(void(^)(BOOL success))block;

// Log in a user
-(void)logInWithUsername:(NSString*)username Password:(NSString*) password block:(void(^)(BOOL success))block;

// Log out a user - this should return instantly
-(void)logout;

// This retrieves menu information for one restaurant and returns instantly
// The block is executed on the main thread when the connection is finished
-(void)getMenuForId:(NSString*)restaurantId withBlock:(void(^)(Menu* menu))block;

-(void)getMenusForIds:(NSArray*)ids withBlock:(void (^)(NSArray*))block;

// Returns true if you are logged in, false otherwise
-(BOOL)loggedIn;

-(int)getReviewFor:(NSString*)dishid;

-(void)imageCountForDish:(NSString*)dishid withBlock:(void(^)(int count))block;

-(void)addReview:(int)rating item:(NSString*)item withImage:(UIImage*)image withBlock:(void(^)(BOOL success))block;

-(void)setPref:(NSString*)pref withValue:(int)value withBlock:(void(^)(BOOL success))block;

-(void)savePrefs;

@end
