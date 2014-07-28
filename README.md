## VLDFacebookManager

Most of the time when a project requires integrating the Facebook SDK it used only for getting the user data and sharing. 
The SDK, however, doesn't make this easy. It requres the developer to know about sessions, check for cached tokens, 
request permissons, etc. `VLDFacebookManager` is a simple wrapper around the Facebook library which tries to hide this complexity. 

Note: `VLDFacebookManager` tries to handle 80% of the cases.
If your use of the Facebook SDK is more advanced this project won't work for you.

## Example Usage

VLDFacebookManager *facebookManager = [[VLDFacebookManager alloc] init];

### Sign in

```objective-c
[facebookManager loginWithCompletionBlock: ^(NSError *error) {
  [self updateLabel];
}];
```

### Get user data

```objective-c
[facebookManager loadCurrentUserWithCompletionBlock: ^(id<FBGraphUser> user, NSError *error) {
  NSLog(@"User: %@, %@", user[@"name"], user[@"email"]]);
}];
```

### Share

```objective-c
FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
params.link = [NSURL URLWithString: @"http://google.com"];
//....
    
[facebookManager shareDialogParams: params
                   completionBlock: ^(NSError *error, BOOL finished) {
                            
}];
```

       
