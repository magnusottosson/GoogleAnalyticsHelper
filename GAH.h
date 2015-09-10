//
// Created by Magnus Ottosson  / Magnus Ottosson on 08/09/15.
//

#import <Foundation/Foundation.h>
#import "GAILogger.h"

typedef NS_ENUM(NSUInteger, GAHLogLevel) {
    kGAHLogLevelNone = 0,
    kGAHLogLevelError = 1,
    kGAHLogLevelWarning = 2,
    kGAHLogLevelInfo = 3,
    kGAHLogLevelVerbose = 4
};

@interface GAH : NSObject


+ (void)setupWithTrackedId:(NSString *)trackerId;

+ (void)setupTracker;

+ (void)trackEventWithCategory:(NSString *)category andAction:(NSString *)action andLabel:(NSString *)label andValue:(NSNumber *)value;

+ (void)trackScreenNamed:(NSString *)screenName;

+ (void)trackExceptionWithMessage:(NSString *)message andFatal:(BOOL)fatal;

+ (void)trackSocialActivityWithNetwork:(NSString *)network andAction:(NSString *)action toTarget:(NSString *)target;

+ (void)trackTimePeriod:(NSNumber *)timing withCategory:(NSString *)category forName:(NSString *)name andLabel:(NSString *)label;

+ (void)trackTimeSpentInBlock:(void (^)())block withCategory:(NSString *)category forName:(NSString *)name andLabel:(NSString *)label;

+ (void)trackAsyncTimeSpentInBlock:(void (^)(void (^)(void)))block withCategory:(NSString *)category forName:(NSString *)name andLabel:(NSString *)label;

+ (void)trackTweetToTarget:(NSString *)target;

+ (void)trackLikeToTarget:(NSString *)target;

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