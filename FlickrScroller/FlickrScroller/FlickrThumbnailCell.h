//
//  FlickrThumbnailCell.h
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrResult.h"

@interface FlickrThumbnailCell : UICollectionViewCell
- (void) updateResultTo:(FlickrResult *)result;
@end
