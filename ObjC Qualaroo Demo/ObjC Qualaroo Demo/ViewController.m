//
//  ViewController.m
//  ObjC Qualaroo Demo
//
//  Created by Mihály Papp on 14/08/2017.
//  Copyright © 2017 Mihály Papp. All rights reserved.
//

#import "ViewController.h"
@import Qualaroo;

@implementation ViewController

- (IBAction)showSurvey:(id)sender {
  [Qualaroo.shared showSurveyWith:@"nps_app"
                               on:self
                           forced:false
                         delegate:nil];
}

- (void)surveyDidCloseWithErrorMessage:(NSString * _Nonnull)errorMessage {
  NSLog(@"surveyDidCloseWithErrorMessage %@", errorMessage);
}
  
- (void)surveyDidDismiss {
  NSLog(@"surveyDidDismiss");
}
  
- (void)surveyDidFinish {
  NSLog(@"surveyDidFinish");
}
  
- (void)surveyDidStart {
  NSLog(@"surveyDidStart");
}
  
@end
