#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PokktModels.h"
#import "PokktAds.h"


@interface PokktNetworkModel : NSObject

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* className;
@property (nonatomic, retain) NSDictionary* customData;
@property (nonatomic, retain) NSString* networkID;
@property (nonatomic, retain) NSString* adFormat;
@property (nonatomic, retain) NSString* intgrationType;
@property (nonatomic, retain) NSString* allotedCacheTime;
@property (nonatomic, retain) NSString* requestUrl;
@property (nonatomic, assign) int type; // network type, TODO: find a better name

- (void)initNetwork:(NSDictionary *)dictionary;
- (BOOL)isPokktNetwork;

@end


@protocol PokktAdNetwork <NSObject>

@required

- (BOOL)checkAdFormatSupport:(NSString *)screenId;
- (void)initNetworkWithNetworkModel:(PokktNetworkModel *)networkModel;
- (PokktNetworkModel *)getNetworkModel;
- (void)cacheAd:(NSString *)screenId;
- (void)showAd:(NSString *)screenId viewController:(UIViewController *)viewController;
- (void)requestNativeAd:(NSString *)screenId withNativeAdConfig:(PokktNativeAdConfig *)nativeAdConfig;
- (void)setCacheTimeOut:(NSString *)screenId;
- (BOOL)isAdCached:(NSString *)screenId;
- (void)notifyDataConsentChanged:(PokktConsentInfo *)consentInfo;
- (void)removeAdConfig:(NSString *)screenId;


@optional

- (void)fetchAd:(NSString *)screenId
      onSuccess:(void(^)(id))successCallback
      onFailure:(void(^)(id))failureHandler;

- (PokktAdConfig *)getCurrentAdConfigForScreenId:(NSString *)screenId;

@end


@interface PokktNetworkDelegate : NSObject

// TODO: correct the names
+ (void)onAdCached:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId rewardValue:(float)reward downLoadTime:(NSString *)downloadTime;
+ (void)onAdFailedToCache:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId errorMessage:(NSString *)errorMsg;
+ (void)onAdDisplayed:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId;
+ (void)onAdFailedToShow:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId errorMessage:(NSString *)errorMsg;
+ (void)onAdClosed:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId adCompleted:(BOOL)adCompleted;
+ (void)onAdClicked:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId;
+ (void)onAdGratified:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId rewardPoint:(float)reward;
+ (void)onNativeAdReady:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId withNativeAd:(PokktNativeAd *)nativeAd withNativeAdConfig:(PokktNativeAdConfig *)nativeAdConfig;
+ (void)onNativeAdFailed:(PokktNetworkModel *)networkModel screenId:(NSString *)screenId errorMessage:(NSString *)errorMsg withNativeAdConfig:(PokktNativeAdConfig *)nativeAdConfig;

@end
