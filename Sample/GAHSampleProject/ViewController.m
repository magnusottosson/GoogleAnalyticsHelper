//
//  ViewController.m
//  GAHSampleProject
//
//  Created by Magnus Ottosson on 10/09/15.
//  Copyright (c) 2015 Magnus Ottosson. All rights reserved.
//

#import "ViewController.h"
#import "GAH.h"

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[GAH trackScreenNamed:@"View Name"];
}


@end
