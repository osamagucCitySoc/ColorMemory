//
//  AppDelegate.m
//  ColourMemory
//
//  Created by OsamaMac on 9/1/14.
//  Copyright (c) 2014 Osama Rabie. All rights reserved.
//

#import "AppDelegate.h"
#import "CONSTANTS.h"
#import <Parse/Parse.h>


@implementation AppDelegate
{
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.audio = YES;
    
    [Parse setApplicationId:@"ns2P9ioCxQJcla4sd3ZaEdbHatVIC3EWhGizPDEz"
                  clientKey:@"APOQvvv961eSM4XlcNIOafcgSjfOSNuCdJc3zgiP"];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if([currSysVer hasPrefix:@"8"])
    {

        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    
    
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"bg" ofType: @"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    self.myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.myAudioPlayer.numberOfLoops = -1;
    [self.myAudioPlayer play];
    
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //infinite loop
    [self.myAudioPlayer stop];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if(self.audio)
    {
        [self.myAudioPlayer play];
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
