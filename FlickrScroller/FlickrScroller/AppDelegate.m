//
//  AppDelegate.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[BUtil navigationControllerWithRoot:[[SearchViewController alloc] initWithNibName:nil bundle:nil]]];
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSUInteger cashSize = 250 * 1024 * 1024;
    NSUInteger cashDiskSize = 250 * 1024 * 1024;
    NSURLCache *imageCache = [[NSURLCache alloc] initWithMemoryCapacity:cashSize diskCapacity:cashDiskSize diskPath:@"imageCachePath"];
    config.URLCache = imageCache;
    config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
    self.sessionImages = [NSURLSession sessionWithConfiguration:config];
    return YES;
}

@end
@implementation UIApplication (SharedAppDelegate)
+(AppDelegate*)app{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}
@end