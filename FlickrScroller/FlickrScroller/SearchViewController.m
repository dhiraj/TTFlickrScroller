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

@interface SearchViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray <NSString *>* arrPastSearches;
@property (nonatomic,strong) UIBarButtonItem * barbuttonSearch;
@property (nonatomic,strong) UISearchBar * searchBar;
@end
@implementation SearchViewController
#pragma mark - Private
- (void) performSearchWithPhrase:(NSString *)searchPhrase{
    DLog(@"Begin search with phrase:%@",searchPhrase);
    //Add into searches array
    
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
    self.title = S_SearchFlickr;
    self.arrPastSearches = [NSMutableArray array];
    self.barbuttonSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(navbarSearchButtonTapped:)];
    self.barbuttonSearch.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.barbuttonSearch;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = S_SearchFlickr;
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
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
@end
