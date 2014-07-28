//
//  VLDAppDelegate.m
//  Example
//
//  Created by Vladimir Angelov on 7/13/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDAppDelegate.h"
#import "VLDViewController.h"
#import "VLDFacebookManager.h"

@implementation VLDAppDelegate

- (BOOL)application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.facebookManager = [[VLDFacebookManager alloc] init];
    [self.facebookManager checkForCachedSession];
    
    VLDViewController *viewController = [[VLDViewController alloc] init];
    viewController.facebookManager = self.facebookManager;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    
    return YES;
}

- (void)applicationDidBecomeActive: (UIApplication *) application {
    [self.facebookManager applicationDidBecomeActive];
}

- (BOOL) application: (UIApplication *) application
             openURL: (NSURL *) url
   sourceApplication: (NSString *) sourceApplication
          annotation: (id) annotation {
    
    [self.facebookManager handleOpenURL: url];
    
    return YES;
}

@end
