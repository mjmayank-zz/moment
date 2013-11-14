//
//  AppDelegate.m
//  moment
//
//  Created by Mayank Jain on 9/21/13.
//  Copyright (c) 2013 Mayank Jain. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LocationManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.db = [FMDatabase databaseWithPath:@"~/Downloads/db.sqlite"];
    [self.db open];
    [self.db executeQuery:@"CREATE TABLE Photos (Lat double, Long double);"];

    [Parse setApplicationId:@"4UrdUCu4ALSAT8vpH1vrLPTI7dW2CjcydIMQCXgb"
                  clientKey:@"ftQDhlqMTJejiNTvibgjKB2xCL4KiWsPXFk2Wqad"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:self.vc];
//    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self.vc]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self.vc]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self.vc presentViewController:logInViewController animated:YES completion:NULL];
    }
    else{
        [self.vc takePhoto];
    }
    return YES;
}

+ (CLLocationManager *)sharedLocationManager
{
    //  Static local predicate must be initialized to 0
    static CLLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CLLocationManager alloc] init];
        sharedInstance = [[CLLocationManager alloc] init];
        sharedInstance.desiredAccuracy = kCLLocationAccuracyBest;
        [sharedInstance startUpdatingLocation];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    LocationManager *manager = [LocationManager initLocationManager];
    [manager stopLocationUpdates];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.vc takePhoto];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    LocationManager *manager = [LocationManager initLocationManager];
    [manager startLocationUpdates];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
