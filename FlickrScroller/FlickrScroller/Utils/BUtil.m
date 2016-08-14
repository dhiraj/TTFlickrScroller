//
//  BasicUtilities.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "BUtil.h"
//#define USE_TEST_COLORS 1

@implementation BUtil
+ (BOOL) isValidArray: ( id ) object
{
    return [self.class isValidArray:object allowingZeroCount:NO];
}

+ (BOOL) isValidDictionary:( id ) object
{
    return [self.class isValidDictionary:object allowingZeroCount:NO];
}
+ (BOOL) isValidArray: ( id ) object allowingZeroCount:(BOOL)allowZeroCount
{
    if (object != nil && ![[NSNull null] isEqual:object])
    {
        if ([object isKindOfClass:[NSArray class]])
        {
            if (allowZeroCount) {
                return YES;
            }
            if ([object count] > 0)
            {
                return YES;
            }
        }
    }
    //    DLog(@"INVALID ARRAY: %@", arr);
    return NO;
}

+ (BOOL) isValidDictionary:( id ) object  allowingZeroCount:(BOOL)allowZeroCount
{
    if ( object != nil && ![[NSNull null] isEqual:object])
    {
        if ([object isKindOfClass:[NSDictionary class]])
        {
            if (allowZeroCount) {
                return YES;
            }
            if ( [object count] > 0 )
            {
                return YES;
            }
        }
    }
    //    DLog(@"INVALID DICTIONARY: %@", dict);
    return NO;
}
+ (BOOL) isValidString: ( id ) valueObject
{
    if ( valueObject != nil && [NSNull null] != valueObject
        && [valueObject isKindOfClass:[NSString class]]
        && [valueObject length] > 0
        )
    {
        return YES;
    }
    //    DLog(@"INVALID STRING:%@", valueObject);
    return NO;
}

+ ( BOOL ) isValidNumber:( id ) object
{
    if ( object != nil &&
        [NSNull null] != object &&
        [object isKindOfClass:[NSNumber class]] )
    {
        return YES;
    }
    
    return NO;
}
+ (BOOL) isValidDataObject:(id)object{
    if (object != nil && [NSNull null] != object && [object isKindOfClass:[NSData class]]) {
        return [object length] > 0;
    }
    return NO;
}
+ (CGFloat) halfOf:(CGFloat)half{
    return floorf(half* 0.5f);
}
+ (CGFloat) oneThirdOf:(CGFloat)full{
    return floorf(full* 0.33333333f);
}
+ (CGFloat) twoThirdsOf:(CGFloat)full{
    return floorf(full* 0.66666666f);
}
+ (CGFloat) oneFourthOf:(CGFloat)full{
    return floorf(full* 0.25f);
}
+ (CGFloat) oneFifthOf:(CGFloat)full{
    return floorf(full* 0.20f);
}
+ (UINavigationController *)navigationControllerWithRoot:(UIViewController *)controller{
    return [[UINavigationController alloc] initWithRootViewController:controller];
}
+ (BOOL) string:(NSString *)stringA isSameAs:(NSString *)stringB{
    return [stringA compare:stringB options:NSCaseInsensitiveSearch] == NSOrderedSame;
}
+ (BOOL) urlRequest:(NSURLRequest *)request1 hasSameURLAs:(NSURLRequest *)request2{
    return [request1.URL.absoluteString compare:request2.URL.absoluteString options:NSCaseInsensitiveSearch] == NSOrderedSame;
}
@end
