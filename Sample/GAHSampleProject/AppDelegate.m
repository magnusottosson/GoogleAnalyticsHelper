//
//  AppDelegate.m
//  GAHSampleProject
//
//  Created by Magnus Ottosson on 10/09/15.
//  Copyright (c) 2015 Magnus Ottosson. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GAH.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[GAH setupWithTrackedId:@"<#Tracking ID#>"];

	/*
	[GAH setTrackBuildInfo:YES];
	[GAH setTrackDeviceInfo:YES];
	[GAH setLogLevel:kGAHLogLevelVerbose];
	 */

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.backgroundColor = [UIColor whiteColor];

	[self.window setRootViewController:[ViewController new]];

	[self.window makeKeyAndVisible];
	return YES;
}
@end
