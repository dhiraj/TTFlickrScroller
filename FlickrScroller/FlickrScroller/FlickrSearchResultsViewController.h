//
//  FlickrSearchResultsViewController.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "ViewController.h"

@interface FlickrSearchResultsViewController : ViewController
- (nullable instancetype) initWithSearchPhrase:(nonnull NSString *) searchPhrase NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil __attribute((unavailable("Search phrase is required")));
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder __attribute((unavailable("Search phrase is required")));

@end
