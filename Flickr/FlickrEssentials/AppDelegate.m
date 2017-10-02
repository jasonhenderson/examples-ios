//
//  AppDelegate.m
//  FlickrEssentials
//
//  Created by Jason Henderson on 4/21/17.
//  Copyright © 2017 CSUMB. All rights reserved.
//

#import "AppDelegate.h"
#import "ErrorMessagingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Make sure defaults are added to settings
    [self registerDefaultsFromSettingsBundle];
    
    // Get the keyboard up so there is no delay when they get into the search window
    UITextField *lagFreeField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.window addSubview:lagFreeField];
    [lagFreeField becomeFirstResponder];
    [lagFreeField resignFirstResponder];
    [lagFreeField removeFromSuperview];
    
    // Setup reachability
    [AppData shared].reachability.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        dispatch_async(dispatch_get_main_queue(), ^{
            DDLogDebug(@"REACHABLE!");
        });
    };
    
    [AppData shared].reachability.unreachableBlock = ^(Reachability*reach)
    {
        DDLogDebug(@"UNREACHABLE!");
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [[AppData shared].reachability startNotifier];
    
    // Setup core data with Magical Record
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelError];
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    [[NSManagedObjectModel MR_defaultManagedObjectModel] kc_generateOrderedSetAccessors];
    
    return YES;
}

- (void)registerDefaultsFromSettingsBundle {
    // this function writes default settings as settings
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = settings[@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:preferences.count];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = prefSpecification[@"Key"];
        if(key && ![[NSUserDefaults standardUserDefaults] objectForKey:key]) {
            defaultsToRegister[key] = prefSpecification[@"DefaultValue"];
            NSLog(@"writing as default %@ to the key %@",prefSpecification[@"DefaultValue"],key);
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Setup the toast/popup for user info
    if (self.errorWindow == nil) {
        [self.window makeKeyAndVisible]; // Must come first
        
        self.errorWindow = [RZMessagingWindow messagingWindow];
        [RZErrorMessenger setDefaultMessagingWindow:self.errorWindow];
        
        // This sets the default...you can change this in the app as/when necessary!
        self.errorWindow.messageViewControllerClass = [ErrorMessagingViewController class];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
