//
//  SearchPhrase.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "SearchPhrase.h"

@implementation SearchPhrase
- (nonnull instancetype) initWithSearchPhrase:(nonnull NSString *)searchPhrase{
    self = [super init];
    if (self) {
        _phrase = [searchPhrase capitalizedString];
        _lastUsed = [NSDate date];
    }
    return self;
}
- (NSUInteger) hash{
    return self.phrase.hash;
}
- (BOOL) isEqual:(id)object{
    return [object isKindOfClass:[SearchPhrase class]] && [[(SearchPhrase *)object phrase] compare:self.phrase options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

@end
