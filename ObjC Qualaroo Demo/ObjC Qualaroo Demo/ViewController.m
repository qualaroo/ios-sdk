//
//  ViewController.m
//  ObjC Qualaroo Demo
//
//  Created by Mihály Papp on 14/08/2017.
//  Copyright © 2017 Mihály Papp. All rights reserved.
//

#import "ViewController.h"
#import <Qualaroo/Qualaroo.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (IBAction)showSurvey:(id)sender {
  [Qualaroo.shared showSurveyWith:@"YourSurveyAlias" on:self];
}

@end
