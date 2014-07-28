//
//  VLDViewController.m
//  Example
//
//  Created by Vladimir Angelov on 7/13/14.
//  Copyright (c) 2014 Vladimir Angelov. All rights reserved.
//

#import "VLDViewController.h"
#import "VLDFacebookManager.h"

@interface VLDViewController ()

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *logoutButton;
@property (strong, nonatomic) UILabel *label;

@end

@implementation VLDViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Facebook test";
    
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle: @"Login"
                                                                    style: UIBarButtonItemStyleBordered
                                                                   target: self
                                                                   action: @selector(loginButtonSelected:)];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithTitle: @"Share"
                                                                    style: UIBarButtonItemStyleBordered
                                                                   target: self
                                                                   action: @selector(shareButtonSelected:)];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle: @"Logout"
                                                                    style: UIBarButtonItemStyleBordered
                                                                   target: self
                                                                   action: @selector(logoutButtonSelected:)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                           target: nil
                                                                           action: nil];
    
    self.toolbarItems = @[ loginButton, space, shareButton, space, logoutButton ];
    
    self.navigationController.toolbarHidden = NO;
    
    self.label = [[UILabel alloc] initWithFrame: CGRectZero];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: self.label];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    [self updateLabel];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.label.frame = self.view.bounds;
}


- (void) loginButtonSelected: (id) sender {
    [self.facebookManager loginWithCompletionBlock:^(NSError *error) {
        [self updateLabel];
    }];
}

- (void) shareButtonSelected: (id) sender {
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString: @"http://google.com"];
    
    [self.facebookManager shareDialogParams: params
                            completionBlock:^(NSError *error, BOOL finished) {
                            
    }];
}

- (void) logoutButtonSelected: (id) sender {
    [self.facebookManager logout];
    [self updateLabel];
}

- (void) updateLabel {
    if(self.facebookManager.isLoggedIn) {
        [self.facebookManager loadCurrentUserWithCompletionBlock: ^(id<FBGraphUser> user, NSError *error) {
            self.label.text = [NSString stringWithFormat: @"%@\n%@", user[@"name"], user[@"email"]];
        }];
    }
    else {
        self.label.text = @"Not logged in";
    }
}

@end
