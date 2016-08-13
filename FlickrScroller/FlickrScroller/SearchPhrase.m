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
- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    NSString * phrase = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"phrase"];
    self = [self initWithSearchPhrase:phrase];
    if (self) {
        _lastUsed = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"lastUsed"];
    }
    return self;
}
- (void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.phrase forKey:@"phrase"];
    [aCoder encodeObject:self.lastUsed forKey:@"lastUsed"];
}
+ (BOOL) supportsSecureCoding{
    return YES;
}
- (NSUInteger) hash{
    return self.phrase.hash;
}
- (BOOL) isEqual:(id)object{
    return [object isKindOfClass:[SearchPhrase class]] && [[(SearchPhrase *)object phrase] compare:self.phrase options:NSCaseInsensitiveSearch] == NSOrderedSame;
}

@end
