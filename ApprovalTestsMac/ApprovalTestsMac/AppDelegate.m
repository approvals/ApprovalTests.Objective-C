//
//  AppDelegate.m
//  ApprovalTestsMac
//
//  Created by Aaron Griffith on 10/30/13.
//  Copyright (c) 2013 Aaron Griffith. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"DEFAULT" forKey:@"diffReporter"];
    [defaults synchronize];
}

@end
