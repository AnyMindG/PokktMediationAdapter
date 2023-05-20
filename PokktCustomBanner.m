#import "PokktCustomBanner.h"
#import "stdatomic.h"

NSString *const BAnyManagerAdMobSDKVersion = @"8.2.1";
NSString *const BAnyManagerAdMobAdapterVersion = @"8.2.1.0";

@interface PokktCustomBanner ()<GADMediationBannerAd, GADBannerViewDelegate> {
    
    
    //deprecated: <GADCustomEventBanner>
    /// The completion handler to call when the ad loading succeeds or fails.
    GADMediationBannerLoadCompletionHandler _loadCompletionHandler;

    /// The ad event delegate to forward ad rendering events to the Google Mobile
    /// Ads SDK.
    id <GADMediationBannerAdEventDelegate> _adEventDelegate;
    
}

/// GAMBannerView banner.
@property (nonatomic, copy) NSString * unitId;
@property(nonatomic, strong) GADRequest *request;
@property(nonatomic, strong) UIViewController *viewController;

//@property(nonatomic, weak, nullable) UIViewController *viewController;

@end

@implementation PokktCustomBanner

static BOOL isPokktSdkInitialized;

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
  NSArray *versionComponents = [BAnyManagerAdMobSDKVersion componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count >= 3) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion = [versionComponents[2] integerValue];
  }
  return version;
}

+ (GADVersionNumber)adapterVersion {
  NSArray *versionComponents = [BAnyManagerAdMobAdapterVersion componentsSeparatedByString:@"."];
  GADVersionNumber version = {0};
  if (versionComponents.count == 4) {
    version.majorVersion = [versionComponents[0] integerValue];
    version.minorVersion = [versionComponents[1] integerValue];
    version.patchVersion =
        [versionComponents[2] integerValue] * 100 + [versionComponents[3] integerValue];
  }
  return version;
}


- (void)loadBannerForAdConfiguration:(nonnull GADMediationBannerAdConfiguration *)adConfiguration
                   completionHandler:
(nonnull GADMediationBannerLoadCompletionHandler)completionHandler{
    
    __block atomic_flag completionHandlerCalled = ATOMIC_FLAG_INIT;
     __block GADMediationBannerLoadCompletionHandler originalCompletionHandler =
         [completionHandler copy];

     _loadCompletionHandler = ^id<GADMediationBannerAdEventDelegate>(
         _Nullable id<GADMediationBannerAd> ad, NSError *_Nullable error) {
       // Only allow completion handler to be called once.
       if (atomic_flag_test_and_set(&completionHandlerCalled)) {
         return nil;
       }

       id<GADMediationBannerAdEventDelegate> delegate = nil;
       if (originalCompletionHandler) {
         // Call original handler and hold on to its return value.
         delegate = originalCompletionHandler(ad, error);
       }

       // Release reference to handler. Objects retained by the handler will also
       // be released.
       originalCompletionHandler = nil;

       return delegate;
     };
    
    NSString *parameter = adConfiguration.credentials.settings[@"parameter"];
    NSDictionary *anyManagerInfoDict = [self dictionaryWithJsonString:parameter];
    
    if ([anyManagerInfoDict objectForKey:@"SCREEN"]) {
        screenName = [anyManagerInfoDict objectForKey:@"SCREEN"];
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
        [PokktDebugger setDebug:isDebug];
    }
    
    [self setGDPR];
    [PokktAds setPokktConfigWithAppId:appId securityKey:securityKey];

    self.viewController = adConfiguration.topViewController;
    
    banner_top = [[UIView alloc] initWithFrame: CGRectMake(0, 0, adConfiguration.adSize.size.width, adConfiguration.adSize.size.height)];
    [banner_top setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.viewController.view addSubview:banner_top];
    
    [PokktAds showAd:screenName withDelegate:self inContainer:banner_top];
    
    NSLog(@"Pokkt ads start caching....");
    _adEventDelegate = _loadCompletionHandler(self, nil);
    
}

- (void)setGDPR
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

#pragma mark Pokkt init delegate

- (void)onPokktSDKInitialized:(NSString *)errorMessage
{
    if(!errorMessage) {
        isPokktSdkInitialized = YES;
    }
}

#pragma mark Pokkt Banner Ads Delegates


- (void)adDisplayResult:(NSString *)screenId isSuccess:(BOOL)success errorMessage:(NSString *)errorMessage {
    if([errorMessage  isEqual: @""] || success == YES) {
        [_adEventDelegate reportImpression];

    } else {
        NSError *err = [NSError errorWithDomain:@"some_domain"
                                           code:100
                                       userInfo:@{
                                                  NSLocalizedDescriptionKey:errorMessage
                                                  }];
        [_adEventDelegate didFailToPresentWithError:err];
    }
}

- (void) adClicked:(NSString*) screenId
{
    [_adEventDelegate reportClick];
}

- (void)adCachingResult:(NSString *)screenId isSuccess:(BOOL)success withReward:(double)reward errorMessage:(NSString *)errorMessage {
}

- (void)adClosed:(NSString *)screenId adCompleted:(BOOL)adCompleted
{
}

- (void)adGratified:(NSString *)screenId withReward:(double)reward
{
}

- (void)bannerCollapsed:(NSString *)screenId
{
}

- (void)bannerExpanded:(NSString *)screenId
{
}

- (void)bannerResized:(NSString *)screenId
{
}


#pragma mark -- GADMediationBannerAd

/// The banner ad view.
//@property(nonatomic, readonly, nonnull) UIView *view;
- (UIView *)view {
    return banner_top;
}

/// Tells the ad to resize the banner. Implement if banner content is resizable.
- (void)changeAdSizeTo:(GADAdSize)adSize {
    CGPoint point = banner_top.frame.origin;
    banner_top.frame = CGRectMake(point.x, point.y, adSize.size.width, adSize.size.height);
}


//#pragma mark -- GADBannerViewDelegate
- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    _adEventDelegate = _loadCompletionHandler(self, nil);
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

