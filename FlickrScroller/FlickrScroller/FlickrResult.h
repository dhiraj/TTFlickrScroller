//
//  FlickrResult.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrResult : NSObject
@property (nonnull,nonatomic,copy) NSString * url_q;
+ (nullable FlickrResult *) resultWithDictionary:(nonnull NSDictionary <NSString *,id>*)dictionary;
+ (nonnull NSArray <FlickrResult *>*) resultsFromArrayOfDictionaries:(nonnull NSArray <NSDictionary <NSString *,id>*>*)dictionaries;
@end
