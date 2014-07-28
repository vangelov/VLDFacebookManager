//
//  VLDFacebookManager.m
//  Example
//
//  Created by Vladimir Angelov on 7/13/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDFacebookManager.h"

@implementation VLDFacebookManager

- (void) checkForCachedSession {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        [FBSession openActiveSessionWithReadPermissions: @[ @"public_profile" ]
                                           allowLoginUI: NO
                                      completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
                                          
                                      }];
    }
}

- (BOOL) isLoggedIn {
    return FBSession.activeSession.state == FBSessionStateOpen ||
           FBSession.activeSession.state == FBSessionStateOpenTokenExtended;
}

- (void) loginWithCompletionBlock: (void (^)(NSError *error)) completionBlock {
    if (self.isLoggedIn) {
        if(completionBlock) {
            completionBlock(nil);
        }
    }
    else {
        [FBSession openActiveSessionWithReadPermissions: @[ @"public_profile" ]
                                           allowLoginUI: YES
                                      completionHandler: ^(FBSession *session, FBSessionState state, NSError *error) {
                                          
                                          if(completionBlock) {
                                              if (!error && state == FBSessionStateOpen){
                                                  completionBlock(nil);
                                              }
                                              else if(error) {
                                                  completionBlock([self processedErrorForError: error]);
                                              }
                                          }
                                      }];
    }
}

- (void) logout {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (FBRequest *) requestForMe {
    NSString *pictureField = ([UIScreen mainScreen].scale > 1) ? @"picture.width(100).height(100)" : @"picture";
    NSArray *fields = @[ @"id", @"name", pictureField, @"location", @"email" ];
    NSString *fieldsParam = [fields componentsJoinedByString: @","];
    
    FBRequest *request = [FBRequest requestForMe];
    request.parameters[@"fields"] = fieldsParam;
    
    return request;
}

- (void) loadCurrentUserWithCompletionBlock: (void (^)(id<FBGraphUser> user, NSError *error)) completionBlock {
    [[self requestForMe] startWithCompletionHandler: ^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
        
        if(completionBlock) {
            if(!error) {
                completionBlock(user, nil);
            }
            else {
                completionBlock(nil, [self processedErrorForError: error]);
            }
        }
    }];
}

- (NSError *) processedErrorForError: (NSError *) error {
    NSString *alertText;
    NSString *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error]){
        alertTitle = @"Something went wrong";
        alertText = [FBErrorUtility userMessageForError:error];
    }
    else {
        if ([FBErrorUtility errorCategoryForError: error] == FBErrorCategoryUserCancelled) {
            NSLog(@"User cancelled login");
        }
        else if ([FBErrorUtility errorCategoryForError: error] == FBErrorCategoryAuthenticationReopenSession){
            alertTitle = @"Session Error";
            alertText = @"Your current session is no longer valid. Please log in again.";
            
            [FBSession.activeSession closeAndClearTokenInformation];
        }
        else {
            NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
            
            alertTitle = @"Something went wrong";
            alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
        }
    }
    
    NSDictionary *userInfo;
    if (alertTitle && alertText) {
        userInfo = @{
                     NSLocalizedDescriptionKey: alertTitle,
                     NSLocalizedFailureReasonErrorKey: alertText,
                     };
        
        
    }
    
    NSError *processedError = [NSError errorWithDomain: NSStringFromClass(self.class)
                                                  code: 0
                                              userInfo: userInfo];
    return processedError;
}

- (BOOL) handleOpenURL: (NSURL *) url {
    return [FBSession.activeSession handleOpenURL: url];
}

- (void) applicationDidBecomeActive {
    [FBAppCall handleDidBecomeActive];
}

- (void) shareDialogParams: (FBLinkShareParams *) params
           completionBlock:(void (^)(NSError *error, BOOL finished))completionBlock {
    
    [self loginWithCompletionBlock: ^(NSError *error) {
        if(!error) {
            if ([FBDialogs canPresentShareDialogWithParams: params]) {
                [self shareDialogParamsUsingTheFacebookApp: params
                                           completionBlock: completionBlock];
            }
            else {
                [self shareDialogParamsUsingWebView: params
                                    completionBlock: completionBlock];
            }
        }
        else if(completionBlock) {
            completionBlock(error, NO);
        }
    }];
}

- (void) shareDialogParamsUsingTheFacebookApp: (FBLinkShareParams *) params
                              completionBlock: (void (^)(NSError *error, BOOL finished)) completionBlock {
    
    [FBDialogs presentShareDialogWithLink: params.link
                                     name: params.name
                                  caption: params.caption
                              description: params.linkDescription
                                  picture: params.picture
                              clientState: nil
                                  handler: ^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      
                                      if(completionBlock) {
                                          BOOL finished = [results[@"completionGesture"] isEqualToString:@"post"];
                                          completionBlock(error, finished);
                                      }
                                  }];
}

- (void) shareDialogParamsUsingWebView: (FBLinkShareParams *) params
                       completionBlock: (void (^)(NSError *error, BOOL finished)) completionBlock {
    
    [FBWebDialogs presentFeedDialogModallyWithSession: nil
                                           parameters: [self dictionaryForShareDialogParams: params]
                                              handler: ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  
                                                  if (result == FBWebDialogResultDialogCompleted) {
                                                      completionBlock(error, YES);
                                                  }
                                                  else {
                                                      completionBlock(error, NO);
                                                  }
                                              }];
}

- (NSDictionary *) dictionaryForShareDialogParams: (FBLinkShareParams *) params {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if(params.name) {
        dictionary[@"name"] = params.name;
    }
    
    if(params.caption) {
        dictionary[@"caption"] = params.caption;
    }
    
    if(params.linkDescription) {
        dictionary[@"description"] = params.linkDescription;
    }
    
    if(params.link) {
        dictionary[@"link"] = params.link.absoluteString;
    }
    
    if(params.picture) {
        dictionary[@"picture"] = params.picture.absoluteString;
    }
    
    return dictionary;
}

@end