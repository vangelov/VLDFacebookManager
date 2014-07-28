//
//  VLDAppDelegate.h
//  Example
//
//  Created by Vladimir Angelov on 7/13/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VLDFacebookManager;

@interface VLDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VLDFacebookManager *facebookManager;

@end
