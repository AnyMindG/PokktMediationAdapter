#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <PokktSDK/PokktSDK.h>
#import <PokktSDK/PokktAdapter.h>
#import <PersonalizedAdConsent/PersonalizedAdConsent.h>

@import GoogleMobileAds;

typedef enum AdStateTypes
{
    No_Ad,
    Interstitial_Ad,
    Video_Ad
} AdType;

@interface PokktCustomInterstitial : NSObject<GADMediationAdapter, PokktAdDelegate, PokktInitDelegate>
{
   
}

@end

