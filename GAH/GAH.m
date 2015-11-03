//
// Created by Magnus Ottosson  / Magnus Ottosson on 08/09/15.
//

#import "GAH.h"
#import <Google/Analytics.h>
#import <GBDeviceInfo/GBDeviceInfo.h>
#import <GoogleAnalytics/GAITracker.h>

NSString *const kTwitterSocialNetwork = @"Twitter";
NSString *const kFacebookSocialNetwork = @"Facebook";
NSString *const kTweetSocialAction = @"Tweet";
NSString *const kLikeSocialAction = @"Like";

@interface GAH ()
@property(nonatomic) BOOL trackDeviceInfo;
@property(nonatomic) BOOL trackBuildInfo;
@property(nonatomic, strong) NSMutableArray *trackers;
@end

@implementation GAH

+ (GAH *)sharedInstance
{
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^
	{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.trackers = [NSMutableArray array];
	}

	return self;
}

+ (void)setupWithTrackerId:(NSString *)trackerId
{
	[self trackerWithId:trackerId];
}

+ (id<GAITracker>)trackerWithId:(NSString *)trackerId
{
	id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:trackerId];
	[[self sharedInstance].trackers addObject:tracker];

	return tracker;
}

+ (void)setupTracker
{
	NSError *configureError;
	[[GGLContext sharedInstance] configureWithError:&configureError];
	NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
}

+ (void)trackEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
	[self send:[[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:value] build]];
}

+ (void)trackScreenNamed:(NSString *)screenName;
{
	for(id<GAITracker> tracker in [self sharedInstance].trackers)
	{
		[tracker set:kGAIScreenName value:screenName];
	}

	[self send:[[GAIDictionaryBuilder createScreenView] build]];
}

+ (void)trackExceptionWithMessage:(NSString *)message fatal:(BOOL)fatal
{
	[self send:[[GAIDictionaryBuilder createExceptionWithDescription:message withFatal:@(fatal)] build]];
}

+ (void)trackSocialActivityWithNetwork:(NSString *)network action:(NSString *)action target:(NSString *)target
{
	[self send:[[GAIDictionaryBuilder createSocialWithNetwork:network action:action target:target] build]];
}

+ (void)trackTimePeriod:(NSNumber *)timing category:(NSString *)category name:(NSString *)name label:(NSString *)label
{
	[self send:[[GAIDictionaryBuilder createTimingWithCategory:category interval:timing name:name label:label] build]];
}

+ (void)trackTimeSpentInBlock:(void (^)())block category:(NSString *)category name:(NSString *)name label:(NSString *)label
{
	NSDate *date = [NSDate date];
	block();
	double timeSpentInMilliSeconds = [date timeIntervalSinceNow] * -1000.0;

	[self send:[[GAIDictionaryBuilder createTimingWithCategory:category interval:@(timeSpentInMilliSeconds) name:name label:label] build]];
}

+ (void)trackAsyncTimeSpentInBlock:(void (^)(void (^)(void)))block category:(NSString *)category name:(NSString *)name label:(NSString *)label
{
	NSDate *date = [NSDate date];
	block(^void(void)
	{
		double timeSpentInMilliSeconds = [date timeIntervalSinceNow] * -1000.0;

		[self send:[[GAIDictionaryBuilder createTimingWithCategory:category interval:@(timeSpentInMilliSeconds) name:name label:label] build]];
	});
}

+ (void)trackTweetToTarget:(NSString *)target
{
	[self trackSocialActivityWithNetwork:kTwitterSocialNetwork action:kTweetSocialAction target:target];
}

+ (void)trackLikeToTarget:(NSString *)target
{
	[self trackSocialActivityWithNetwork:kFacebookSocialNetwork action:kLikeSocialAction target:target];
}

+ (void)trackErrorWithDescription:(NSString *)description error:(NSError *)error
{
	[self send:[[GAIDictionaryBuilder createExceptionWithDescription:error.localizedDescription withFatal:@NO] build]];
}

+ (void)trackErrorWithDescription:(NSString *)description error:(NSError *)error fatal:(BOOL)fatal
{
	[self send:[[GAIDictionaryBuilder createExceptionWithDescription:error.localizedDescription withFatal:@(fatal)] build]];
}

+ (void)setTracksUncaughtExceptions:(BOOL)tracksUncaughtExceptions
{
	[[GAI sharedInstance] setTrackUncaughtExceptions:tracksUncaughtExceptions];
}

+ (BOOL)tracksUncaughtExceptions
{
	return [[GAI sharedInstance] trackUncaughtExceptions];
}

+ (void)setSyncInterval:(NSTimeInterval)syncInterval
{
	[GAI sharedInstance].dispatchInterval = syncInterval;
}

+ (NSTimeInterval)syncInterval
{
	return [GAI sharedInstance].dispatchInterval;
}

+ (BOOL)optOut
{
	return [GAI sharedInstance].optOut;
}

+ (void)setOptOut:(BOOL)optOut
{
	[[GAI sharedInstance] setOptOut:optOut];
}

+ (void)setAnonymizeIp:(BOOL)anonymizeIp
{
	for(id<GAITracker> tracker in [self sharedInstance].trackers)
	{
		[tracker set:kGAIAnonymizeIp value:anonymizeIp ? @"1" : @"0"];
	}
}

+ (void)setLogLevel:(GAHLogLevel)logLevel
{
	[[GAI sharedInstance].logger setLogLevel:(GAILogLevel) logLevel];
}

+ (BOOL)trackDeviceInfo
{
	return [self sharedInstance].trackDeviceInfo;
}

+ (void)setTrackDeviceInfo:(BOOL)trackDeviceInfo
{
	[[self sharedInstance] setTrackBuildInfo:trackDeviceInfo];
}

+ (BOOL)trackBuildInfo
{
	return [self sharedInstance].trackBuildInfo;
}

+ (void)setTrackBuildInfo:(BOOL)trackBuildInfo
{
	[[self sharedInstance] setTrackBuildInfo:trackBuildInfo];
}

+ (void)send:(NSDictionary *)parameters
{
	if ([self sharedInstance].trackBuildInfo)
	{
		[self sendDeviceInfo];
	}

	if ([self sharedInstance].trackDeviceInfo)
	{
		[self sendBuildInfo];
	}

	for(id<GAITracker> tracker in [self sharedInstance].trackers)
	{
		[tracker send:parameters];
	}
}

+ (void)sendDeviceInfo
{
	[self setCustomDimensionAtIndex:2 name:@"device" value:[GBDeviceInfo deviceInfo].modelString];
	[self setCustomDimensionAtIndex:3 name:@"jailbroken" value:[GBDeviceInfo deviceInfo].isJailbroken ? @"YES" : @"NO"];
}

+ (void)sendBuildInfo
{
	NSString *appName = [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
	NSString *appShortVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
	NSString *appVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];

	NSString *buildString = [NSString stringWithFormat:@"%@ v%@ (build %@)", appName, appShortVersion, appVersion];

	[self setCustomDimensionAtIndex:1 name:@"build" value:buildString];
}

+ (void)setCustomDimensionAtIndex:(NSUInteger)index name:(NSString *)name value:(NSString *)value
{
	[[GAI sharedInstance].defaultTracker set:[GAIFields customDimensionForIndex:index] value:[NSString stringWithFormat:@"%@ - %@", name, value]];
}

+ (NSString *)urlEncodeString:(NSString *)string
{
	NSString *s = [[string stringByReplacingOccurrencesOfString:@" " withString:@"-"] lowercaseString];
	return [s stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end