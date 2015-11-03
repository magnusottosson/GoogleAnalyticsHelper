//
// Created by Magnus Ottosson  / Magnus Ottosson on 08/09/15.
//

#import <Foundation/Foundation.h>
#import "GAILogger.h"

@protocol GAITracker;
@protocol GAITracker;

typedef NS_ENUM(NSUInteger, GAHLogLevel) {
    kGAHLogLevelNone = 0,
    kGAHLogLevelError = 1,
    kGAHLogLevelWarning = 2,
    kGAHLogLevelInfo = 3,
    kGAHLogLevelVerbose = 4
};

/**
 *  This is the standard string to describe Twitter as the network when tracking social activity
 */
extern NSString *const kTwitterSocialNetwork;
/**
 *  This is the standard string to describe Facebook as the network when tracking social activity
 */
extern NSString *const kFacebookSocialNetwork;
/**
 *  This is the standard string to describe Tweeting as the action when tracking social activity
 */
extern NSString *const kTweetSocialAction;
/**
 *  This is the standard string to describe liking as the action when tracking social activity
 */
extern NSString *const kLikeSocialAction;

@interface GAH : NSObject

+ (void)setupWithTrackerId:(NSString *)trackerId __deprecated;

+ (id <GAITracker>)trackerWithId:(NSString *)trackerId;

+ (void)setupTracker;

+ (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

+ (void)trackScreenNamed:(NSString *)screenName;

+ (void)trackExceptionWithMessage:(NSString *)message fatal:(BOOL)fatal;

+ (void)trackSocialActivityWithNetwork:(NSString *)network action:(NSString *)action target:(NSString *)target;

+ (void)trackTimePeriod:(NSNumber *)timing category:(NSString *)category name:(NSString *)name label:(NSString *)label;

+ (void)trackTimeSpentInBlock:(void (^)())block category:(NSString *)category name:(NSString *)name label:(NSString *)label;

+ (void)trackAsyncTimeSpentInBlock:(void (^)(void (^)(void)))block category:(NSString *)category name:(NSString *)name label:(NSString *)label;

+ (void)trackTweetToTarget:(NSString *)target;

+ (void)trackLikeToTarget:(NSString *)target;

+ (void)trackErrorWithDescription:(NSString *)description;

+ (void)trackErrorWithDescription:(NSString *)description fatal:(BOOL)fatal;

+ (void)setTracksUncaughtExceptions:(BOOL)tracksUncaughtExceptions;

+ (BOOL)tracksUncaughtExceptions;

+ (void)setSyncInterval:(NSTimeInterval)syncInterval;

+ (NSTimeInterval)syncInterval;

+ (BOOL)optOut;

+ (void)setOptOut:(BOOL)optOut;

+ (void)setAnonymizeIp:(BOOL)anonymizeIp;

+ (void)setLogLevel:(GAHLogLevel)logLevel;

+ (BOOL)trackDeviceInfo;

+ (void)setTrackDeviceInfo:(BOOL)trackDeviceInfo;

+ (BOOL)trackBuildInfo;

+ (void)setTrackBuildInfo:(BOOL)trackBuildInfo;

@end