#import "PokktCustomRewardedVideo.h"
#import "stdatomic.h"

NSString *const RAnyManagerAdMobSDKVersion = @"8.2.1";
NSString *const RAnyManagerAdMobAdapterVersion = @"8.2.1.0";

@interface PokktCustomRewardedVideo () {
    NSString *pokktScreenName;
    NSString *appId;
    NSString *securityKey;
    BOOL isDebug;
    NSString *thirdPartyId;
    
    // The completion handler to call when the ad loading succeeds or fails.
    GADMediationRewardedLoadCompletionHandler _loadCompletionHandler;
    
    /// The ad event delegate to forward ad rendering events to the Google Mobile Ads SDK.
    id <GADMediationRewardedAdEventDelegate> _adEventDelegate;
}

@property(nonatomic, weak, nullable) UIViewController *viewController;


@end

@implementation PokktCustomRewardedVideo

+ (void)setUpWithConfiguration:(nonnull GADMediationServerConfiguration *)configuration
             completionHandler:(nonnull GADMediationAdapterSetUpCompletionBlock)completionHandler{

    if (completionHandler) {
        completionHandler(nil);
    }
}

+ (nullable Class<GADAdNetworkExtras>)networkExtrasClass {
    return nil;
}

+ (GADVersionNumber)adSDKVersion {
  NSArray *versionComponents = [RAnyManagerAdMobSDKVersion componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count >= 3) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion = [versionComponents[2] integerValue];
  }
  return version;
}

+ (GADVersionNumber)adapterVersion {
  NSArray *versionComponents = [RAnyManagerAdMobAdapterVersion componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count == 4) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion =
        [versionComponents[2] integerValue] * 100 + [versionComponents[3] integerValue];
  }
  return version;
}

-(void)loadRewardedAdForAdConfiguration:(GADMediationRewardedAdConfiguration *)adConfiguration
                      completionHandler:
(GADMediationRewardedLoadCompletionHandler)completionHandler {
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
    __block GADMediationRewardedLoadCompletionHandler originalCompletionHandler =
    [completionHandler copy];
    
    _loadCompletionHandler = ^id<GADMediationRewardedAdEventDelegate>(
                                                                      _Nullable id<GADMediationRewardedAd> ad, NSError *_Nullable error) {
                                                                          // Only allow completion handler to be called once.
                                                                          if (atomic_flag_test_and_set(&completionHandlerCalled)) {
                                                                              return nil;
                                                                          }
                                                                          
                                                                          id<GADMediationRewardedAdEventDelegate> delegate = nil;
                                                                          if (originalCompletionHandler) {
                                                                              // Call original handler and hold on to its return value.
                                                                              delegate = originalCompletionHandler(ad, error);
                                                                          }
                                                                          
                                                                          // Release reference to handler. Objects retained by the handler will also be released.
                                                                          originalCompletionHandler = nil;
                                                                          
                                                                          return delegate;
                                                                      };
    
    NSString *parameter = adConfiguration.credentials.settings[@"parameter"];
    NSDictionary *anyManagerInfoDict = [self dictionaryWithJsonString:parameter];
    
    if ([anyManagerInfoDict objectForKey:@"SCREEN"]) {
        pokktScreenName = [anyManagerInfoDict objectForKey:@"SCREEN"];
    }
    
    if ([anyManagerInfoDict objectForKey:@"APPID"]) {
        appId = [anyManagerInfoDict objectForKey:@"APPID"];
    }
    
    if ([anyManagerInfoDict objectForKey:@"SECKEY"]) {
        securityKey = [anyManagerInfoDict objectForKey:@"SECKEY"];
    }
    
    if ([anyManagerInfoDict objectForKey:@"TPID"]) {
        thirdPartyId = [anyManagerInfoDict objectForKey:@"TPID"];
        [PokktAds setThirdPartyUserId:thirdPartyId];
    }
    
    if ([anyManagerInfoDict objectForKey:@"DBG"]) {
        isDebug = [[anyManagerInfoDict objectForKey:@"DBG"] boolValue];
        [PokktDebugger setDebug: isDebug];
    }
    
    NSLog(@"AdMob Custom Network Initialised...");
    _viewController = adConfiguration.topViewController;
    
    [self setGDPR];
    
    
    [PokktAds setPokktConfigWithAppId:appId securityKey:securityKey];
    [PokktAds cacheAd:pokktScreenName withDelegate:self];
    
    NSLog(@"Pokkt ads start caching....");
    _adEventDelegate = _loadCompletionHandler(self, nil);
    
    
}


- (void)setUp
{
    [self setGDPR];
    
    [PokktAds setPokktConfigWithAppId:appId securityKey:securityKey];
    
    // [optional] set it to true if you want to enable logs for PokktSDK
    [PokktDebugger setDebug:isDebug];
    
    [PokktAds setThirdPartyUserId:thirdPartyId];
    
    // OPTIONAL but we SUGGEST you to implement delegates as it will help you to determine the status of your request
    [PokktAds cacheAd:pokktScreenName withDelegate:self];
    
    NSLog(@"Pokkt ads start caching....");
}


- (void)presentFromViewController:(nonnull UIViewController *)viewController
{
    NSLog(@"Pokkt ads presenting ad...");
    [self setGDPR];
    [PokktAds showAd:pokktScreenName withDelegate:self presentingVC:viewController];
}


-(void)setGDPR
{
    PACConsentStatus status =  [[PACConsentInformation sharedInstance] consentStatus];
    PokktConsentInfo *consentInfo = [[PokktConsentInfo alloc] init];
    if (status == PACConsentStatusNonPersonalized)
    {
        consentInfo.isGDPRApplicable = true;
        consentInfo.isGDPRConsentAvailable = false;
    }
    else if (status == PACConsentStatusPersonalized)
    {
        consentInfo.isGDPRApplicable = true;
        consentInfo.isGDPRConsentAvailable = true;
    }
    
    [PokktAds setPokktConsentInfo:consentInfo];
}


#pragma mark Pokkt Video Ads Delegates


- (void) adClicked:(NSString*) screenId
{
    [_adEventDelegate reportClick];
}

- (void) adGratified:(NSString*) screenId withReward:(double) reward
{
    GADAdReward *aReward =
    [[GADAdReward alloc] initWithRewardType:@""
                               rewardAmount:(NSDecimalNumber *)[NSDecimalNumber numberWithDouble:reward]];
    [_adEventDelegate didRewardUser];
}

- (void) adClosed:(NSString*) screenId adCompleted:(BOOL) adCompleted
{
    [_adEventDelegate didEndVideo];
    [_adEventDelegate willDismissFullScreenView];
}

- (void)adCachingResult:(NSString *)screenId isSuccess:(BOOL)success withReward:(double)reward errorMessage:(NSString *)errorMessage {
    if([errorMessage  isEqual: @""] || success == YES) {
        NSLog(@"Pokkt ads cached successfully...");
        [_adEventDelegate willPresentFullScreenView];
    } else {
        NSLog(@"Pokkt ads caching failed...");
        NSError *err = [NSError errorWithDomain:@"Error"
                                           code:0
                                       userInfo:@{
            NSLocalizedDescriptionKey:errorMessage
        }];
        [_adEventDelegate didFailToPresentWithError:err];
    }
}

- (void)adDisplayResult:(NSString *)screenId isSuccess:(BOOL)success errorMessage:(NSString *)errorMessage {
    if([errorMessage  isEqual: @""] || success == YES) {
        [_adEventDelegate didStartVideo];
        [_adEventDelegate reportImpression];
    } else {
        NSLog(@"Video ad falied to show for %@ with error %@", screenId, errorMessage);
        NSError *err = [NSError errorWithDomain:@"Error"
                                           code:0
                                       userInfo:@{
            NSLocalizedDescriptionKey:errorMessage
        }];
        [_adEventDelegate didFailToPresentWithError:err];
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err == nil && [result isKindOfClass:[NSDictionary class]]) {
        
        return result;
    }
    
    return nil;
}



@end

