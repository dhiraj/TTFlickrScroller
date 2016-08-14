//
//  FlickrThumbnailCell.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "FlickrThumbnailCell.h"
#import "AppDelegate.h"

@interface FlickrThumbnailCell()
@property (nonatomic,weak) FlickrResult * myResult;
@property (nonatomic,strong) UIImageView * ivThumbnail;
@property (nonatomic,strong) NSURLSessionDataTask * task;
@end
@implementation FlickrThumbnailCell
#pragma mark - Private
- (void) updateDisplayViews{
    if (self.task != nil) {
        [self.task cancel];
        self.task = nil;
    }
    self.ivThumbnail.image = nil;
    self.task = [[UIApplication app].sessionImages dataTaskWithURL:[NSURL URLWithString:self.myResult.url_q] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (error.code != -999) {
                DLog(@"Error:%@ downloading thumbnail, response:%@",error,response);
            }
            return ;
        }
        if (![BUtil isValidDataObject:data]) {
            DLog(@"Error getting data from downloaded file!");
            return;
        }
        UIImage * image = [UIImage imageWithData:data];
        if (!image) {
            DLog(@"Couldn't decode image from downloaded thumbnail data");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.ivThumbnail.image = image;
        });
    }];
    [self.task resume];
}
#pragma mark - LifeCycle
- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        _ivThumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_ivThumbnail];
    }
    return self;
}
- (void) layoutSubviews{
    [super layoutSubviews];
    self.ivThumbnail.frame = self.contentView.bounds;
}
#pragma mark - Exposed
- (void) updateResultTo:(nonnull FlickrResult *)result{
    self.myResult = result;
    [self updateDisplayViews];
}
@end
