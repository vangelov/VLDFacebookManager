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

#import "FBAdMobCustomEventInterstitial.h"

@interface FBAdMobCustomEventInterstitial ()

@property (nonatomic, retain) FBInterstitialAd *fbInterstitialAd;

@end

@implementation FBAdMobCustomEventInterstitial

@synthesize delegate = delegate_;

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)request{

    if ([serverParameter length] == 0) {
        [self.delegate customEventInterstitial:self didFailAd:nil];
        return;
    }

    self.fbInterstitialAd = [[FBInterstitialAd alloc ] initWithPlacementID:serverParameter];
    self.fbInterstitialAd.delegate = self;
    [self.fbInterstitialAd loadAd];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController{
    if (!self.fbInterstitialAd || !self.fbInterstitialAd.isAdValid) {
    } else {
        [self.delegate customEventInterstitialWillPresent:self];
        [self.fbInterstitialAd showAdFromRootViewController:rootViewController];
    }
}

- (void) dealloc {
    _fbInterstitialAd.delegate = nil;
    [_fbInterstitialAd release];
    [super dealloc];
}

#pragma mark FBInterstitialAdDelegate methods

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    [self.delegate customEventInterstitial:self didReceiveAd:interstitialAd];
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd
{
    [self.delegate customEventInterstitialWillLeaveApplication:self];
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd
{
    [self.delegate customEventInterstitialDidDismiss:self];
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd
{
    [self.delegate customEventInterstitialWillDismiss:self];
}

@end
