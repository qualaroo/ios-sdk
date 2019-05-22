//
//  AppDelegate.m
//  ObjC Qualaroo Demo
//
//  Created by Mihály Papp on 14/08/2017.
//  Copyright © 2017 Mihály Papp. All rights reserved.
//

#import "AppDelegate.h"
@import Qualaroo;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  [Qualaroo.shared configureWithApiKey:@"NjgyMTc6MGQ2YmQ3NTdmMmRkNjkzZGM3OGU3ZWE4YmI2MDRmNWRhNmI1Y2I4Yjo2NjIxOA=="
                          autotracking:YES];
  
  return YES;
}

@end
