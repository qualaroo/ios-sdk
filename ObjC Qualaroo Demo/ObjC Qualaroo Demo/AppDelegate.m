//
//  AppDelegate.m
//  ObjC Qualaroo Demo
//
//  Created by Mihály Papp on 14/08/2017.
//  Copyright © 2017 Mihály Papp. All rights reserved.
//

#import "AppDelegate.h"
#import <Qualaroo/Qualaroo.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  NSError *error = nil;
  [Qualaroo.shared configureWithApiKey:@"YourApiKey==" autotracking:YES error:&error];
  if (error) {
    NSLog(@"%@", error.debugDescription);
  }
  
  return YES;
}

@end
