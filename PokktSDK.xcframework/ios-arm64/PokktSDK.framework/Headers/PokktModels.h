#import <Foundation/Foundation.h>
typedef enum : int
{
    VIDEO = 0,
    BANNER = 1,
    INTERSTITIAL = 3,
    INGAME_BRANDING = 4,
    NATIVE = 5
} AdFormatType;

/**
 * This is ad request configuration. Developer should supply this in almost every ad related method.
 */


@interface PokktNativeAdConfig : NSObject {
}

@property (nonatomic , strong) NSString *version; /* Version of the Native Markup version in use.*/

/*
  Description - The context in which the ad appears.
 
 Params:
  1 - Content-centric context such as newsfeed, article, image gallery, video
 gallery, or similar.
  2 - Social-centric context such as social network feed, email, chat, or similar.
  3- Product context such as product listings, details, recommendations.
  500+ - To be defined by the exchange.
 reviews, or similar
 
 Note: recommended
 
 */
@property (nonatomic , strong) NSString *context;

/*
  Description - Next-level context in which the ad appears.
 
 Params:
  10 - General or mixed content..
  11 - Primarily article content (which of course could include images, etc
 as part of the article).
  12- Primarily video content.
  13 - Primarily audio content.
  14 - Primarily image content
  15 - User-generated content - forums, comments, etc
  20 - General social content such as a general social network
  21 - Primarily email content
  22 - Primarily chat/IM content
  30 - Content focused on selling products, whether digital or physical
  31 - Application store/marketplace
  32 - Product reviews site primarily (which may sell product secondarily)
  500+ - To be defined by the exchange
 
 Note: optional
 
 */

@property (nonatomic , strong) NSString *subContext;

/*
  Description - The FORMAT of the ad you are purchasing, separate from the surrounding context.
 
 Params:
  1 - In the feed of content - for example as an item inside the organic
 feed/grid/listing/carousel.
  2 - In the atomic unit of the content - IE in the article page or single image page
  3 - Outside the core content - for example in the ads section on the right
 rail, as a banner-style placement near the content, etc.
  4 - Recommendation widget, most commonly presented below the article content.
  500+ - To be defined by the exchange
 
 Note: recommended
 */

@property (nonatomic , strong) NSString *placementType;

/*
  Description - The number of identical placements in this Layout.
 
 Params:
  1 - In the feed of content - for example as an item inside the organic
 feed/grid/listing/carousel.
  2 - In the atomic unit of the content - IE in the article page or single image page
  3 - Outside the core content - for example in the ads section on the right
 rail, as a banner-style placement near the content, etc.
  4 - Recommendation widget, most commonly presented below the article content.
  500+ - To be defined by the exchange
 
 Note: optional
 */

@property (nonatomic , strong) NSString *placementCount;

/*
  Description - 0 for the first ad, 1 for the second
 ad, and so  on..
 
 Note: optional
 */

@property (nonatomic , strong) NSString *sequence;

/*
  Description - Whether the supply source / impression supports returning an assetsurl instead of an asset object.
 0 or the absence of the field indicates no such support.
 
 Note: optional
 
 Need to discuss
 */


@property (nonatomic , strong) NSString *aURLSupport;

/*
  Description - Whether the supply source / impression supports returning a dco url instead of an asset object. 0 or the absence of the field indicates no such support. Beta feature   .
 
 Note: optional
 
 Need to discuss
 */
@property (nonatomic , strong) NSString *dURLSupport;

/*
  Description - Set to 1 when the native ad supports buyer-specific privacy
 notice. Set to 0 (or    field    absent) when the native ad doesn’t support custom privacy links or if
 support is unknown.
 
 Note: optional
 */

@property (nonatomic , strong) NSString *privacy;
@property (nonatomic , assign) int titleLength;
@property (nonatomic , assign) int mainImageHeight;
@property (nonatomic , assign) int mainImageWidth;
@property (nonatomic , assign) int iconImageHeight;
@property (nonatomic , assign) int iconImageWidth;

@property (nonatomic , assign) int sponsoredLength;
@property (nonatomic , assign) int descriptionLength;
@property (nonatomic , assign) int ctaTextLength;

@property (nonatomic , assign) int maxVideoDuration;
@property (nonatomic , assign) int minVideoDuration;

/**
     * Applies to mainImageMandatory and videoMandatory.
     * -1 : false - not needed
     * 1 :  true - mandatory
     * 0 : default - required becomes 0 and server may send or may not send the asset
     */

@property (nonatomic , assign) int mainImageRequired;
@property (nonatomic , assign) int videoRequired;


@property (nonatomic , assign) BOOL setStartMuted;

@property (nonatomic, assign) int adFormat;

@end

@interface PokktAdConfig : NSObject

/*! @abstract screenName Screen name for which ad is requested. */

@property (nonatomic, retain) NSString* screenName;

/*! @abstract isRewarded rewarded or non rewarded ad request */

@property (nonatomic, assign) BOOL isRewarded;

/*! @abstract adFormat is a type for ad such as  0:video, 1: banner, 3: interstitial , default is 0 */

@property (nonatomic, assign) int adFormat;

@property (nonatomic, assign) int responseFormat;

@property (nonatomic, strong) id adCampaign;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, assign) BOOL isAdCached;

@property (nonatomic, strong) PokktNativeAdConfig *nativeConfig;

//- (NSString *) getKey;

@end

@interface PokktAdPlayerViewConfig : NSObject

/*! @abstract defaultSkipTime duration to skip ad, default is 0 */

@property (nonatomic, assign) int defaultSkipTime;

/*! @abstract shouldAllowSkip set YES or NO to skip ad, if 'YES' it will allow user to skip ad , default is YES */

@property (nonatomic, assign) BOOL shouldAllowSkip;

/*! @abstract shouldAllowMute set YES or NO to skip ad,if 'YES' it will allow user to Mute ad , default is YES */

@property (nonatomic, assign) BOOL shouldAllowMute;

/*! @abstract shouldConfirmSkip set YES or NO to skip ad, default is YES */

@property (nonatomic, assign) BOOL shouldConfirmSkip;

/*! @abstract skipConfirmMessage custom message for skip alert*/

@property (nonatomic, strong) NSString * skipConfirmMessage;

/*! @abstract skipConfirmYesLabel custom text for skip alert 'YES' Label*/

@property (nonatomic, strong) NSString * skipConfirmYesLabel;

/*! @abstract skipConfirmNoLabel custom text for skip alert 'NO' Label*/

@property (nonatomic, strong) NSString * skipConfirmNoLabel;

/*! @abstract skipTimerMessage custom message for remianing time to skip ad*/

@property (nonatomic, strong) NSString * skipTimerMessage;

/*! @abstract incentiveMessage custom message for remianing time to get reward*/

@property (nonatomic, strong) NSString * incentiveMessage;

/*! @abstract learnMoreMessage custom message for learn more text*/

@property (nonatomic, strong) NSString * learnMoreMessage;

/*! @abstract shouldCollectFeedback set YES or NO , If Yes it will allow user to send feedback for ad.*/

@property (nonatomic, assign) BOOL shouldCollectFeedback;

/*! @abstract isAudioEnabled set YES or NO to mute ad,if 'YES' ad will be mute. , default is NO */

@property (nonatomic, assign) BOOL isAudioEnabled;

@end

@interface PokktUserInfo : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *age;
@property (nonatomic, retain) NSString *sex;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *maritalStatus;
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *mobileNumber;
@property (nonatomic, retain) NSString *emailAddress;
@property (nonatomic, retain) NSString *facebookId;
@property (nonatomic, retain) NSString *twitterHandle;
@property (nonatomic, retain) NSString *educationInformation;
@property (nonatomic, retain) NSString *nationality;
@property (nonatomic, retain) NSString *employmentStatus;
@property (nonatomic, retain) NSString *maturityRating;

@end

