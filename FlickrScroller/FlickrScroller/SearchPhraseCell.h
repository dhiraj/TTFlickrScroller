//
//  SearchPhraseCell.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPhrase.h"

@interface SearchPhraseCell : UITableViewCell
- (void) updateSearchPhraseTo:(nonnull SearchPhrase *)phrase;
@end
