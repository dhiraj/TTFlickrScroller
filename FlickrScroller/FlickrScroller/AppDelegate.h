//
//  AppDelegate.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

@import UIKit;
#import "DebugHelpers.h"
#import "BUtil.h"
#import "TranslationStrings.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSURLSession * sessionImages;
@end

@interface UIApplication (SharedAppDelegate)
+(AppDelegate*)app;
@end
