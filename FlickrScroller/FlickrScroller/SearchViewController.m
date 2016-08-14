//
//  SearchViewController.m
//  FlickrScroller
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "FlickrSearchResultsViewController.h"
#import "SearchPhrase.h"
#import "SearchPhraseCell.h"

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <SearchPhrase *>* arrPastSearches;
@property (nonatomic,strong) UIBarButtonItem * barbuttonSearch;
@property (nonatomic,strong) UISearchBar * searchBar;
@property (nonatomic,strong) NSString * filepathSearches;
@property (nonatomic,strong) NSSortDescriptor * descDateDescending;
@property (nonatomic,strong) NSIndexSet * isetFilteredSearches;
@end


#define SINGLECELL @"SINGLECELL"
@implementation SearchViewController
#pragma mark - Private
- (void) reloadTableView{
    [self.tableView reloadData];
}
- (void) saveSearches{
    NSFileManager * fileMan = [NSFileManager defaultManager];
    [fileMan removeItemAtPath:self.filepathSearches error:nil];
    BOOL success = [NSKeyedArchiver archiveRootObject:self.arrPastSearches toFile:self.filepathSearches];
    DLog(@"Wrote to file:%d",success);
}
- (void) loadSearches{
    NSFileManager * fileMan = [NSFileManager defaultManager];
    if ([fileMan fileExistsAtPath:self.filepathSearches]) {
        self.arrPastSearches = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filepathSearches];
    }
    else{
        self.arrPastSearches = [NSMutableArray array];
    }
}
- (void) addSearchPhraseText:(NSString *)searchText{
    SearchPhrase * testPhrase = [[SearchPhrase alloc] initWithSearchPhrase:searchText];
    NSInteger index = [self.arrPastSearches indexOfObject:testPhrase];
    if (index != NSNotFound) {
        [self.arrPastSearches removeObjectAtIndex:index];
    }
    [self.arrPastSearches insertObject:testPhrase atIndex:0];
    [self saveSearches];
    [self reloadTableView];
}
- (void) deleteSearchPhraseAtIndex:(NSIndexPath *)indexPath{
    if (self.isetFilteredSearches) {
        //We need to first translate filtered indexpath to actual index path
        SearchPhrase * phrase = [self itemAtIndexPath:indexPath];
        NSInteger index = [self.arrPastSearches indexOfObject:phrase];
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    if (indexPath.row > self.arrPastSearches.count) {
        DLog(@"Invalid index for searches: %@",indexPath);
        return;
    }
    [self.arrPastSearches removeObjectAtIndex:indexPath.row];
    [self saveSearches];
    [self reloadTableView];
}
- (void) performSearchWithPhrase:(NSString *)searchPhrase{
    DLog(@"Begin search with phrase:%@",searchPhrase);
    //Add into searches array
    [self addSearchPhraseText:searchPhrase];
    
    //Load results view controller
    FlickrSearchResultsViewController * vc = [[FlickrSearchResultsViewController alloc] initWithSearchPhrase:searchPhrase];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) performSearchFromSearchBarText{
    [self.searchBar resignFirstResponder];
    NSString * searchPhrase = self.searchBar.text;
    self.searchBar.text = nil;
    self.isetFilteredSearches = nil;
    [self performSearchWithPhrase:searchPhrase];
}
- (void) performSearchFromSearchPhrase:(SearchPhrase *)searchPhrase{
    self.searchBar.text = searchPhrase.phrase;
    [self performSearchFromSearchBarText];
}
- (void) filterSearchWithText:(nullable NSString *)filter{
    if (![BUtil isValidString:filter]) {
        self.isetFilteredSearches = nil;
    }
    else{
        self.isetFilteredSearches = [self.arrPastSearches indexesOfObjectsPassingTest:^BOOL(SearchPhrase * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [obj.phrase rangeOfString:filter options:NSCaseInsensitiveSearch].location != NSNotFound;
        }];
    }
    [self reloadTableView];
}
- (SearchPhrase *) itemAtIndexPath:(NSIndexPath *)indexPath{
    SearchPhrase * item = nil;
    if (self.isetFilteredSearches) {
        NSArray * filtered = [self.arrPastSearches objectsAtIndexes:self.isetFilteredSearches];
        item = filtered[indexPath.row];
    }
    else{
        item = self.arrPastSearches[indexPath.row];
    }
    return item;
}
#pragma mark - Actions
- (void) navbarSearchButtonTapped:(id)sender{
    [self performSearchFromSearchBarText];
}

#pragma mark - LifeCycle
- (void) viewDidLoad{
    self.descDateDescending = [NSSortDescriptor sortDescriptorWithKey:@"lastUsed" ascending:NO];
    self.filepathSearches = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"searches"] stringByAppendingPathExtension:@"plist"];
    self.title = S_SearchFlickr;
    [self loadSearches];
    self.barbuttonSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(navbarSearchButtonTapped:)];
    self.barbuttonSearch.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.barbuttonSearch;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = S_SearchFlickr;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 44.0f;
    [self.tableView registerClass:[SearchPhraseCell class] forCellReuseIdentifier:SINGLECELL];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSArray * ipaths = [self.tableView indexPathsForSelectedRows];
    if ([BUtil isValidArray:ipaths]) {
        [self.tableView deselectRowAtIndexPath:ipaths[0] animated:YES];
    }
    if ([self tableView:self.tableView numberOfRowsInSection:0] == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.searchBar becomeFirstResponder];
        });
    }
}

#pragma mark - UISearchBar
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([BUtil isValidString:searchText]) {
        self.barbuttonSearch.enabled = YES;
        [self filterSearchWithText:searchText];
    }
    else{
        [self filterSearchWithText:nil];
        self.barbuttonSearch.enabled = NO;
    }
}
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self performSearchFromSearchBarText];
}

#pragma mark - UITableView
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isetFilteredSearches) {
        return self.isetFilteredSearches.count;
    }
    return self.arrPastSearches.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchPhraseCell * cell = [self.tableView dequeueReusableCellWithIdentifier:SINGLECELL];
    SearchPhrase * item = [self itemAtIndexPath:indexPath];
    [cell updateSearchPhraseTo:item];
    return cell;
}
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteSearchPhraseAtIndex:indexPath];
    }
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchPhrase * item = [self itemAtIndexPath:indexPath];
    [self performSearchFromSearchPhrase:item];
}

@end
