/**
 * Copyright 2014 Facebook, Inc.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to
 * use, copy, modify, and distribute this software in source code or binary
 * form for use in connection with the web and mobile services and APIs
 * provided by Facebook.
 *
 * As with any software that integrates with the Facebook platform, your use
 * of this software is subject to the Facebook Developer Principles and
 * Policies [http://developers.facebook.com/policy/]. This copyright notice
 * shall be included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 */

#import "FBAdMobCustomEventBanner.h"

@interface FBAdMobCustomEventBanner ()

@property (nonatomic, retain) FBAdView *fbAdView;

@end

@implementation FBAdMobCustomEventBanner

@synthesize delegate = delegate_;

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request
{
    if ([serverParameter length] == 0) {
        [self.delegate customEventBanner:self didFailAd:nil];
        return;
    }

    self.fbAdView = [[FBAdView alloc]initWithPlacementID:serverParameter
                                                  adSize:kFBAdSize320x50
                                      rootViewController:[self.delegate viewControllerForPresentingModalView]];
    self.fbAdView.delegate = self;
    [self.fbAdView loadAd];
}

- (void) dealloc {
    _fbAdView.delegate = nil;
    [_fbAdView release];
    [super dealloc];
}

#pragma mark FBAdViewDelegate methods

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error;
{
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void)adViewDidLoad:(FBAdView *)adView;
{
    [self.delegate customEventBanner:self didReceiveAd:self.fbAdView];
}

- (void)adViewDidClick:(FBAdView *)adView
{
    [self.delegate customEventBanner:self clickDidOccurInAd:self.fbAdView];
}

@end
