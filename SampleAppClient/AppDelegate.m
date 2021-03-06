//
//  AppDelegate.m
//  SampleAppClient
//
//  Created by James Wang on 1/17/14.
//  Copyright (c) 2014 James Wang. All rights reserved.
//

#import "AppDelegate.h"
#import <NewRelicAgent/NewRelic.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <CrashReporter/CrashReporter.h>
#import <Crittercism.h>
#import <HockeySDK/HockeySDK.h>
#import <FoglightAPM/FoglightAPM.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //NewRelic
    [NewRelicAgent startWithApplicationToken:@"AA7d20584120ca855128c2bee19b56ef98fcd3073a" withoutSecurity:YES];
    [NRLogger setLogLevels:NRLogLevelALL];
    [NRLogger setLogTargets:NRLogTargetConsole|NRLogTargetFile];
    
    // internal configs
    [[NSUserDefaults standardUserDefaults] setObject:@"http://10.8.255.239:7630/archiverProxy?op=uploadhitdata" forKey:@"com.dell.FoglightAPM.beaconURL"];
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"com.dell.FoglightAPM.uploadInterval"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"com.dell.FoglightAPM.compressFoglightHit"];
    
    
    // standard configs
    FoglightAPMConfig *config = [FoglightAPMConfig defaultConfig];
    config.key = @"f34f7302-156d-42f9-8c0d-d5ec6193d5bd";
    config.applicationName = @"Wordpress";
    config.enableCrashTracking = YES;
    config.logLevel = FoglightLogLevelVerbose;
    [[FoglightAPM sharedInstance] startWithConfig:config];
    
    
    // Crashlytic
    [Fabric with:@[CrashlyticsKit]];
    
    // Crittercism
    [Crittercism enableWithAppID:@"54d332cd51de5e9f042ed67e"];
    
    // HockeyApp
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"08a4a4aba39d0e7d729467b935e77abd"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    // PLCrashReporter
//    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
//    NSError *error;
//    
//    if ([crashReporter hasPendingCrashReport]) {
//        [self handleCrashReport];
//    }
//    
//    if (![crashReporter enableCrashReporterAndReturnError:&error]) {
//        NSLog(@"Warning: Could not enable crash reporter: %@", error);
//    }

    return YES;
}

- (void)handleCrashReport {
    PLCrashReporter *reporter = [PLCrashReporter sharedReporter];
    NSData* data;
    NSError *error;
    
    data = [reporter loadPendingCrashReportDataAndReturnError:&error];
    if (data == nil) {
        NSLog(@"Could not load crash report : %@", error);
    } else {
        NSString *crashReportText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"crash report text %@", crashReportText);
        
        PLCrashReport *report = [[PLCrashReport alloc] initWithData:data error:&error];
        if (report != nil) {
            NSString *iOSText = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
            NSLog(@"%@", iOSText);
            
            
            NSLog(@"Crashed on %@", report.systemInfo.timestamp);
            NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address);
            
            for (PLCrashReportThreadInfo *threadInfo in report.threads) {
                NSLog(@"ThreadInfo : %ld ", (long) threadInfo.threadNumber);
                for (PLCrashReportStackFrameInfo *stackFrame in threadInfo.stackFrames) {
                    NSLog(@"  StackFrame %@", stackFrame);
                }
                for (PLCrashReportRegisterInfo *theRegister in threadInfo.registers) {
                    NSLog(@"  Register : %@", theRegister.registerName);
                }
            }
            for (PLCrashReportBinaryImageInfo *imageInfo in report.images) {
                NSLog(@"Image Info : %@ ", imageInfo.debugDescription);
            }
        }
    }
    
    [reporter purgePendingCrashReport];
    return;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
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

@end
