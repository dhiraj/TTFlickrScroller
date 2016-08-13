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
#define CELLSPACING 1.0f
#define PAGESIZE @"20"
@implementation FlickrSearchResultsViewController
#pragma mark - Private
- (void) addIntoResults:(NSArray <FlickrResult *>*)arrMoreResults{
    NSRange range = NSMakeRange(self.arrResults.count, arrMoreResults.count);
    NSIndexSet * iset = [NSIndexSet indexSetWithIndexesInRange:range];
    NSMutableArray * ipaths = [NSMutableArray arrayWithCapacity:arrMoreResults.count];
    [iset enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * ipath = [NSIndexPath indexPathForRow:idx inSection:0];
        [ipaths addObject:ipath];
    }];
    DLog("Adding %d results, total:%d",arrMoreResults.count,self.arrResults.count + arrMoreResults.count);
    [self.arrResults addObjectsFromArray:arrMoreResults];
    [self.collectionView insertItemsAtIndexPaths:ipaths];
}
- (void) loadNextPage{
    if (self.hasMaxed || self.loadingPage) {
        DLog(@"Not loading when finished / already loading");
        return;
    }
    self.loadingPage = YES;
    self.page += 1;
    NSMutableArray * queryItems = [@[
                                    [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.search"]
                                    ,[NSURLQueryItem queryItemWithName:@"api_key" value:@"0845bbb79445bf10a0a1ea948aa5dae7"]
                                    ,[NSURLQueryItem queryItemWithName:@"per_page" value:PAGESIZE]
                                    ,[NSURLQueryItem queryItemWithName:@"format" value:@"json"]
                                    ,[NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"]
                                    ,[NSURLQueryItem queryItemWithName:@"extras" value:@"url_q"]
                                    ,[NSURLQueryItem queryItemWithName:@"text" value:self.searchPhrase]
                                    ,[NSURLQueryItem queryItemWithName:@"safe_search" value:@"1"]
                                    ,[NSURLQueryItem queryItemWithName:@"page" value:@(self.page).stringValue]
                                    ] mutableCopy];
    NSURLComponents * components = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/"];
    components.queryItems = queryItems;
    NSURL * url = components.URL;
    DLog(@"Generated URL:%@",url);
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error && error.code != -999) {
            DLog(@"Caught error response, flagging as maxed");
            self.hasMaxed = YES;
            return ;
        }
        if (![BUtil isValidDataObject:data]) {
            DLog(@"Invalid data object received, flagging as maxed");
            self.hasMaxed = YES;
            return ;
        }
        NSError * errorSerialization = nil;
        NSDictionary * dictResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&errorSerialization];
        if (errorSerialization) {
            DLog(@"Error de-serializing data, flagging as maxed");
            self.hasMaxed = YES;
        }
        if(![BUtil isValidDictionary:dictResponse]){
            DLog(@"Error getting dictionary from response, flagging as maxed");
            self.hasMaxed = YES;
            return ;
        }
        NSDictionary * dictPhotos = dictResponse[@"photos"];
        if (![BUtil isValidDictionary:dictPhotos]) {
            DLog(@"Error getting photos dictionary, flagging as maxed");
            self.hasMaxed = YES;
            return ;
        }
        NSArray <NSDictionary <NSString *,id>*>* arrPhoto = dictPhotos[@"photo"];
        if (![BUtil isValidArray:arrPhoto]) {
            DLog(@"Couldn't get a valid photo dictionaries array!");
            self.hasMaxed = YES;
            return ;
        }
        NSArray <FlickrResult *>* flickrResults = [FlickrResult resultsFromArrayOfDictionaries:arrPhoto];
        if (![BUtil isValidArray:flickrResults]) {
            DLog(@"Couldn't convert array of dictionaries into array of flickr results");
            self.hasMaxed = YES;
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.loadingPage = NO;
            [self addIntoResults:flickrResults];
        });
//        DLog(@"Response:%@, Error:%@",response,error);
    }];
    [task resume];
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
    self.title = self.searchPhrase;
    self.arrResults = [NSMutableArray array];
    self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    self.collectionViewLayout.minimumInteritemSpacing = CELLSPACING;
    self.collectionViewLayout.minimumLineSpacing = CELLSPACING;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[FlickrThumbnailCell class] forCellWithReuseIdentifier:CELLCLASS];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.clipsToBounds = YES;
    [self.view addSubview:self.collectionView];
    [self loadNextPage];
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect mybounds = self.view.bounds;
    self.collectionView.frame = mybounds;
    CGFloat width = CGRectGetWidth(mybounds);
    CGFloat numColums = 3.0f;
    CGFloat gap = ((CELLSPACING * 0.5f) * numColums);
    CGFloat cellWidth = (width / numColums) - gap;
    self.collectionViewLayout.itemSize = CGSizeMake(cellWidth, cellWidth);
}

#pragma mark - UICollectionView
- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (targetContentOffset->y + CGRectGetHeight(scrollView.bounds) >= scrollView.contentSize.height - 100) {
        [self loadNextPage];
    }
}
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
