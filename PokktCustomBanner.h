#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PokktSDK/PokktSDK.h>
#import <PokktSDK/PokktAdapter.h>
#import <PersonalizedAdConsent/PersonalizedAdConsent.h>

@import GoogleMobileAds;

@interface PokktCustomBanner : NSObject <GADMediationAdapter, PokktAdDelegate>
{
    UIView *banner_top;
    NSString *screenName;
    NSString *appId;
    NSString *securityKey;
    NSString *thirdPartyId;
    BOOL isDebug;
}

@end

