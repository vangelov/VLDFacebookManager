//
//  VLDFacebookManager.h
//  Example
//
//  Created by Vladimir Angelov on 7/13/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface VLDFacebookManager : NSObject

@property (readonly) BOOL isLoggedIn;

- (void) checkForCachedSession;
- (BOOL) handleOpenURL: (NSURL *) url;
- (void) applicationDidBecomeActive;
- (void) loginWithCompletionBlock: (void (^)(NSError *error)) completionBlock;
- (void) logout;
- (void) loadCurrentUserWithCompletionBlock: (void (^)(id<FBGraphUser> user, NSError *error)) completionBlock;

- (void) shareDialogParams: (FBLinkShareParams *) params
           completionBlock: (void (^)(NSError *error, BOOL finished)) completionBlock;

@end

