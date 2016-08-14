//
//  BasicUtilities.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface BUtil : NSObject

+ (BOOL) isValidString:(nullable id)valueObject;
+ (BOOL) isValidArray:(nullable NSArray *)arr;
+ (BOOL) isValidDictionary:(nullable NSDictionary *)dict;
+ (BOOL) isValidArray: (nullable id)object allowingZeroCount:(BOOL)allowZeroCount;
+ (BOOL) isValidDictionary:(nullable id)object allowingZeroCount:(BOOL)allowZeroCount;
+ (BOOL) isValidDataObject:(nullable id)object;
+ (nonnull UINavigationController *)navigationControllerWithRoot:(nonnull UIViewController *)controller;
@end
