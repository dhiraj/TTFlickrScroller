//
//  SearchPhrase.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchPhrase : NSObject
@property (nonnull, nonatomic, copy, readonly) NSString * phrase;
@property (nonnull, nonatomic, strong, readonly) NSDate * lastUsed;
- (nonnull instancetype) initWithSearchPhrase:(nonnull NSString *)searchPhrase NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype) init  __attribute((unavailable("Search phrase is required")));
@end
