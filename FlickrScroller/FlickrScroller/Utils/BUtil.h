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

#define GAP_4X 32.0f
#define GAP_3X 24.0f
#define GAP_2X 16.0f
#define GAP 8.0f
#define GAP_HALF 4.0f
#define GAP_QUARTER 2.0f

#define COLOR_TEST_RED [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.3f]
#define COLOR_TEST_GREEN [UIColor colorWithRed:0 green:1.0f blue:0 alpha:0.3f]
#define COLOR_TEST_BLUE [UIColor colorWithRed:0 green:0 blue:1.0f alpha:0.3f]

#define COLOR_DIVIDER [UIColor colorWithHex:@"454545"]

+ (BOOL) isValidString:(nullable id)valueObject;
+ (BOOL) isValidArray:(nullable NSArray *)arr;
+ (BOOL) isValidDictionary:(nullable NSDictionary *)dict;
+ (BOOL) isValidNumber:(nullable id)object;
+ (BOOL) isValidArray: (nullable id)object allowingZeroCount:(BOOL)allowZeroCount;
+ (BOOL) isValidDictionary:(nullable id)object allowingZeroCount:(BOOL)allowZeroCount;
+ (BOOL) isValidDataObject:(nullable id)object;
+ (CGFloat) halfOf:(CGFloat)half;
+ (CGFloat) oneThirdOf:(CGFloat)full;
+ (CGFloat) twoThirdsOf:(CGFloat)full;
+ (CGFloat) oneFourthOf:(CGFloat)full;
+ (CGFloat) oneFifthOf:(CGFloat)full;
+ (nonnull UINavigationController *)navigationControllerWithRoot:(nonnull UIViewController *)controller;
+ (nonnull UILabel *) uiLabelWithText:(nullable NSString *)string addToView:(nullable UIView *)parent;
+ (BOOL) string:(nonnull NSString *)stringA isSameAs:(nonnull NSString *)stringB;
+ (BOOL) urlRequest:(nonnull NSURLRequest *)request1 hasSameURLAs:(nonnull NSURLRequest *)request2;
@end
