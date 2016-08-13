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
@end


#define SINGLECELL @"SINGLECELL"
@implementation SearchViewController
#pragma mark - Private
- (void) reloadTableView{
    [self.tableView reloadData];
}
- (void) saveSearches{
    
}
- (void) loadSearches{
    
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
- (void) deleteSearchPhrase:(SearchPhrase *)phrase{
    
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
    [self performSearchWithPhrase:searchPhrase];
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
    self.arrPastSearches = [NSMutableArray array];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
    [self loadSearches];
}
- (void) viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"");
    NSArray * ipaths = [self.tableView indexPathsForSelectedRows];
    if ([BUtil isValidArray:ipaths]) {
        [self.tableView deselectRowAtIndexPath:ipaths[0] animated:YES];
    }
}


#pragma mark - UISearchBar
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([BUtil isValidString:searchText]) {
        self.barbuttonSearch.enabled = YES;
    }
    else{
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
    return self.arrPastSearches.count;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchPhraseCell * cell = [self.tableView dequeueReusableCellWithIdentifier:SINGLECELL];
    SearchPhrase * item = self.arrPastSearches[indexPath.row];
    [cell updateSearchPhraseTo:item];
    return cell;
}

@end
