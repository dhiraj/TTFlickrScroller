//
//  FlickrResult.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "FlickrResult.h"
#import "AppDelegate.h"

@implementation FlickrResult
+ (nullable FlickrResult *) resultWithDictionary:(nonnull NSDictionary <NSString *,id>*)dictionary{
    FlickrResult * result = [[FlickrResult alloc] init];
    if (!result) {
        DLog(@"Couldn't create nsobject?");
        return nil;
    }
    result.url_q = dictionary[@"url_q"];
    if (![BUtil isValidString:result.url_q]) {
        DLog(@"Couldn't parse url_q from dictionary:%@",dictionary);
        return nil;
    }
    return result;
}
+ (nonnull NSArray <FlickrResult *>*) resultsFromArrayOfDictionaries:(NSArray <NSDictionary <NSString *,id>*>*)dictionaries{
    NSMutableArray * results = [NSMutableArray arrayWithCapacity:dictionaries.count];
    for (NSDictionary <NSString *,id>* dict  in dictionaries) {
        FlickrResult * result = [FlickrResult resultWithDictionary:dict];
        if (!result) {
            DLog(@"Couldn't create result, continuing");
            continue;
        }
        [results addObject:result];
    }
    return results;
}
@end
