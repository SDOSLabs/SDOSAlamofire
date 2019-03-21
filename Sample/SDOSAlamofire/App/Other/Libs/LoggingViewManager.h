//
//  LoggingViewManager.h
//  SDOSAFNetworkingJSONModel
//
//  Created by Antonio Jesús Pallares on 11/11/16.
//  Copyright 2016 SDOS. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://blog.mugunthkumar.com)
//  More information about this template on the post http://mk.sg/89
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoggingViewManager : NSObject


+ (void)log:(NSString *)format, ...;
+ (void)logString:(NSString *)strToLog;
+ (void)cleanLogView;
+ (void)presentLoggingViewInViewController:(UIViewController *)viewController;

@end
