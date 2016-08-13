//
//  FlickrSearchResultsViewController.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "FlickrSearchResultsViewController.h"
#import "AppDelegate.h"
#import "FlickrResult.h"
#import "FlickrThumbnailCell.h"

@interface FlickrSearchResultsViewController()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,copy) NSString * searchPhrase;
@property (nonatomic,strong) NSMutableArray <FlickrResult *>* arrResults;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL hasMaxed;
@property (nonatomic,assign) BOOL loadingPage;

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * collectionViewLayout;
@end

#define CELLCLASS @"CELLCLASS"
@implementation FlickrSearchResultsViewController
#pragma mark - Private

#pragma mark - LifeCycle
- (nullable instancetype) initWithSearchPhrase:(nonnull NSString *) searchPhrase {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (![BUtil isValidString:searchPhrase]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"A valid search phrase is required" userInfo:nil];
        }
        _searchPhrase = searchPhrase;
    }
    return self;
}
- (void) viewDidLoad{
    [super viewDidLoad];
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    self.collectionViewLayout.minimumInteritemSpacing = 0.5f;
    self.collectionViewLayout.minimumLineSpacing = 1.0f;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[FlickrThumbnailCell class] forCellWithReuseIdentifier:CELLCLASS];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.clipsToBounds = YES;
    [self.view addSubview:self.collectionView];
}
#pragma mark - UICollectionView
@end
