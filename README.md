## VLDFacebookManager

Most of the time when a project requires Facebook integration it only consists of getting the user data and sharing. 
The Facebook SDK, however, doesn't make this easy. It requires the developer to know about sessions, check for cached tokens, request permissons, etc. `VLDFacebookManager` is a simple wrapper around the Facebook library which tries to hide this complexity. 

Note: `VLDFacebookManager` tries to handle what I consider to be 80% of the cases.
If your use of the Facebook SDK is more advanced this project won't work for you.

## Example Usage
```objective-c
VLDFacebookManager *facebookManager = [[VLDFacebookManager alloc] init];
```
### Sign in

```objective-c
[facebookManager loginWithCompletionBlock: ^(NSError *error) {
  //...
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
  //...             
}];
```

For more info check the Example project.

       
