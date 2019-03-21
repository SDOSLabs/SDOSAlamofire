//
//  LoggingViewManager.m
//  SDOSAFNetworkingJSONModel
//
//  Created by Antonio Jesús Pallares on 11/11/16.
//  Copyright 2016 SDOS. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89	
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "LoggingViewManager.h"
#import "MALoggingViewController.h"

@interface LoggingViewManager ()

@property (strong, nonatomic) MALoggingViewController *logger;

@end

@implementation LoggingViewManager

#pragma mark -
#pragma mark Singleton Methods

+ (LoggingViewManager*)sharedInstance {

	static LoggingViewManager *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
			});
		}

		return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {	

	return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;	
}


#pragma mark -
#pragma mark Custom Methods

-(MALoggingViewController *)logger {
    if (!_logger) {
        _logger = [MALoggingViewController new];
    }
    return _logger;
}

+ (void)log:(NSString *)format, ... {
    [[self sharedInstance].logger logToView:format];
}

+ (void)logString:(NSString *)strToLog {
    [[self sharedInstance].logger logToViewString:strToLog];
}

+ (void)cleanLogView {
    [self sharedInstance].logger = nil;
}

+ (void)presentLoggingViewInViewController:(UIViewController *)viewController {
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[self sharedInstance].logger];
    
    [viewController presentViewController:navController animated:YES completion:nil];
}

@end
