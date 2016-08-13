//
//  SearchPhraseCell.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "SearchPhraseCell.h"
@interface SearchPhraseCell()
@property (nonatomic,weak) SearchPhrase * myPhrase;
@end
@implementation SearchPhraseCell
#pragma mark - Private
- (void) updateDisplayViews{
    self.textLabel.text = self.myPhrase.phrase;
    [self.textLabel setNeedsLayout];
}
#pragma mark - LifeCycle
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}
#pragma mark - Exposed
- (void) updateSearchPhraseTo:(SearchPhrase *)phrase{
    self.myPhrase = phrase;
    [self updateDisplayViews];
}
@end
