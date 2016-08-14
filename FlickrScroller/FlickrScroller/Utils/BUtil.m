//
//  BasicUtilities.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "BUtil.h"

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

+ (BOOL) isValidDataObject:(id)object{
    if (object != nil && [NSNull null] != object && [object isKindOfClass:[NSData class]]) {
        return [object length] > 0;
    }
    return NO;
}
+ (UINavigationController *)navigationControllerWithRoot:(UIViewController *)controller{
    return [[UINavigationController alloc] initWithRootViewController:controller];
}
@end
