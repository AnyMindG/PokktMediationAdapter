#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PokktModels.h"

@class PokktNativeAd;

@protocol PokktInitDelegate <NSObject>

- (void)onPokktSDKInitialized:(NSString *)errorMessage;

@end


@protocol PokktAdDelegate <NSObject>

@optional
- (void)adCachingResult:(NSString *)screenId isSuccess:(BOOL)success withReward:(double)reward errorMessage:(NSString *)errorMessage;
- (void)adDisplayResult:(NSString *)screenId isSuccess:(BOOL)success errorMessage:(NSString *)errorMessage;
- (void)adClosed:(NSString *)screenId adCompleted:(BOOL)adCompleted;
- (void)adClicked:(NSString *)screenId;
- (void)adGratified:(NSString *)screenId withReward:(double)reward;

- (void)adReady:(NSString *)screenId withNativeAd:(PokktNativeAd *)pokktNativeAd;
- (void)adFailed:(NSString *)screenId error:(NSString *)errorMessage;

@end

@interface PokktNativeAd : NSObject

- (UIView *)getMediaView;
- (UIView *)getImageView;
- (NSDictionary *)getNativeAssets;
- (UIImageView *)getIcon;
- (UILabel *)getTitle;
- (UIButton *)getLink;
- (UILabel *)getBody;
- (UILabel *)getSponsor;
- (UILabel *)getRating;
- (int)getRatingValue;
- (UILabel *)getPrice;
- (UILabel *)getCTA;
- (UILabel *)getLike;
- (UILabel *)getDownload;
- (UILabel *)getSalePrice;
- (UILabel *)getPhoneNumber;

- (UILabel *)getAddress;
- (UILabel *)getAdditionalDescriptive;
- (UILabel *)getDisplayURL;

- (void)recordImpression;
- (void)dismiss;

// internal for pokkt sdk
- (instancetype)initWithAd:(id)ad image:(id)imageAd icon:(id)icon title:(id)title clickUrl:(id)clickUrl
                      body:(id)body sponsor:(id)sponsor rating:(id)rating assets:(id)assets price:(id)price cta:(id)CTA like:(id)like download:(id)download sale:(id)sale phone:(id)phone address : (id)address descriptiveView : (id)descriptiveView displayURL : (id )displayURL;
- (id)getAd;

@end

@interface PokktNativeAdViewBinder : NSObject

- (instancetype)initWithNativeRootView:(UIView *)rootView mediaView:(UIView *)mediaView icon:(UIView *)icon title:(UILabel *)title ctaButton:(UIButton *)cta body:(UILabel *)body sponsor:(UILabel *)sponsor rating:(UILabel *)rating price:(UILabel *)price like:(UILabel *)like cta:(UILabel *)ctaText download:(UILabel *)download salePrice:(UILabel *)salePrice phoneNumber:(UILabel *)phone address:(UILabel *)address additionalDescriptive:(UILabel *)additionalDesc displayURL:(UILabel *)displayURL;

- (void) populateView:(PokktNativeAd *)nativeAd;
@end


@interface PokktConsentInfo : NSObject

@property (nonatomic) BOOL isGDPRApplicable;
@property (nonatomic) BOOL isGDPRConsentAvailable;

@end


@interface PokktAds : NSObject

+ (void)setPokktConfigWithAppId:(NSString *)appId securityKey:(NSString *)securityKey;
+ (void)setPokktConfigWithParams:(NSDictionary *)params;

+ (void)initSDKWithAppId:(NSString *)appId securityKey:(NSString *)securityKey delegate:(id<PokktInitDelegate>)delegate;

#pragma mark for internal use only - dont expose in the release build
+ (void)setIpAddress:(NSString *)ip;

+ (BOOL)isAdCached:(NSString *)screenId;
+ (void)cacheAd:(NSString *)screenId withDelegate:(id<PokktAdDelegate>)delegate;

+ (void)showAd:(NSString *)screenId withDelegate:(id<PokktAdDelegate>)delegate presentingVC:(UIViewController *)viewController;
+ (void)showAd:(NSString *)screenId withDelegate:(id<PokktAdDelegate>)delegate inContainer:(UIView *)adContainer;

+ (void)requestNativeAd:(NSString *)screenId withDelegate:(id<PokktAdDelegate>)delegate withNativeAdConfig:(PokktNativeAdConfig *)nativeAdConfig;
+ (void)dismissAd:(NSString *)screenId;

+ (void)setPokktConsentInfo:(PokktConsentInfo *)consentObject;
+ (PokktConsentInfo *)getPokktConsentInfo;

+ (void)setDestinationAppStoreIdentifier:(NSString *)identifier;
+ (void)setSourceAppStoreIdentifier:(NSString *)identifier;

/*
 ATTrackingManagerAuthorizationStatusNotDetermined = 0,
 ATTrackingManagerAuthorizationStatusRestricted = 1,
 ATTrackingManagerAuthorizationStatusDenied = 2,
 ATTrackingManagerAuthorizationStatusAuthorized = 3
 */
+ (void)setAPPTrackingAuthorizationStatus:(int)trackingStatus;

+ (NSString *)getSDKVersion;
+ (void)setThirdPartyUserId:(NSString *)userId;
+ (void)setCallbackExtraParam:(NSDictionary *)extraParam;
+ (void)setUserDetails:(PokktUserInfo *)userInfo;
+ (void)setPokktAdPlayerViewConfig:(PokktAdPlayerViewConfig *)adPlayerViewConfig;

@end


@interface PokktDebugger : NSObject

+ (BOOL)isDebugEnabled;
+ (void)setDebug:(BOOL)isDebug;
+ (void)printLog:(NSString *)message;
+ (void)showToast:(NSString *)message
   viewController:(UIViewController *)viewController;
+ (void)exportLog:(UIViewController *)viewController;

@end

