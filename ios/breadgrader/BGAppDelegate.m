//
//  BGAppDelegate.m
//  breadgrader
//
//  Created by Brian Kim on 3/5/13.
//  Copyright (c) 2013 bread. All rights reserved.
//

#import "BGAppDelegate.h"
#import "BGBackupManager.h"
#import "BGCoreDataController.h"
#import "BGCourseListViewController.h"
#import "UIBarButtonItem+borderlessButtons.h"

#import "Appirater.h"


@interface BGAppDelegate()
{
    NSString *relinkUserId;
}

@property (nonatomic, strong) BGCourseListViewController *root;
@end

@implementation BGAppDelegate

- (BOOL)iPhone
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // get the root view controller and set its managed object context
    
    if (self.iPhone)
    {
        self.root = [[BGCourseListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.root];
        
        self.window.rootViewController = nav;
        self.root.wantsActive = YES;
    }
    else // ipad
    {
        
    }
    self.root.moc = [[BGCoreDataController sharedController] managedObjectContext];
    
    [self.window makeKeyAndVisible];
    
    [Appirater setAppId: @"685434577"];
    [Appirater appLaunched: YES];

    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if (![[BGBackupManager sharedManager] handleOpenURL: url])
    {
        NSLog( @"the backup manager failed to handle the url" );
    }
    return YES;
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
    
    [Appirater appEnteredForeground: YES];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[BGCoreDataController sharedController] save];
}


@end
