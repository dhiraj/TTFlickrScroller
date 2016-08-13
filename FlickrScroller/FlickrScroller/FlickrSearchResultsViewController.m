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

@interface FlickrSearchResultsViewController()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy) NSString * searchPhrase;
@property (nonatomic,strong) NSMutableArray <FlickrResult *>* arrResults;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) BOOL hasMaxed;
@property (nonatomic,assign) BOOL loadingPage;

@property (nonatomic,strong) UICollectionView * collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout * collectionViewLayout;
@end

#define CELLCLASS @"CELLCLASS"
#define CELLSPACING 0.5f
@implementation FlickrSearchResultsViewController
#pragma mark - Private
- (void) loadNextPage{
    
}
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
    self.collectionViewLayout.minimumInteritemSpacing = CELLSPACING;
    self.collectionViewLayout.minimumLineSpacing = 1.0f;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[FlickrThumbnailCell class] forCellWithReuseIdentifier:CELLCLASS];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.clipsToBounds = YES;
    [self.view addSubview:self.collectionView];
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect mybounds = self.view.bounds;
    self.collectionView.frame = mybounds;
    CGFloat width = CGRectGetWidth(mybounds);
    CGFloat numColums = 3.0f;
    CGFloat gap = (CELLSPACING * numColums) - CELLSPACING;
    CGFloat cellWidth = (width / numColums) - gap;
    self.collectionViewLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - UICollectionView
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(CELLSPACING, CELLSPACING, CELLSPACING, CELLSPACING);
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.arrResults.count;
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FlickrThumbnailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLCLASS forIndexPath:indexPath];
    [cell updateResultTo:self.arrResults[indexPath.row]];
    return cell;
}
@end
