//
//  FlickrScrollerUITests.m
//  FlickrScrollerUITests
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FlickrScrollerUITests : XCTestCase

@end

@implementation FlickrScrollerUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAllUICases {
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    XCUIApplication * app = [[XCUIApplication alloc] init];
    sleep(1);
    XCUIElement * searchField = app.navigationBars[@"Search Flickr"].searchFields[@"Search Flickr"];
    [searchField tap];
    [searchField typeText:@"Kittens\n"];
    XCTAssertTrue(app.staticTexts[@"Loading..."].hittable); //Loading should initially be visible
    sleep(2.0);
    XCTAssertFalse(app.staticTexts[@"Loading..."].hittable); //And then be hidden when results are available
    for (NSUInteger i = 0; i <10; i++) { //Simulate scrolling through the result x times
        [app swipeUp];
    }
    XCUIElement * backButton = app.navigationBars.buttons[@"Search Flickr"];
    [backButton tap];
    
    //Test the search phrase adding, tapping, filtering and deleting
    [searchField tap];
    [searchField typeText:@"One\n"]; //Add One
    [backButton tap];
    [searchField tap];
    [searchField typeText:@"two\n"]; //Add Two
    [backButton tap];
    [app.tables.staticTexts[@"Two"] tap]; //Tap on earlier added two phrase
    [backButton tap];
    [searchField tap];
    [searchField typeText:@"two"]; //Filter to show two
    [app.tables.staticTexts[@"Two"] tap]; //Tap on the filtered two phrase
    [backButton tap];
    [searchField tap];
    [searchField typeText:@"three"];
    [app.keyboards.buttons[@"Search"] tap]; //Search button on keyboard should work
    [backButton tap];
    [searchField tap];
    [searchField typeText:@"four\n"]; //Add four
    [backButton tap];
    [searchField tap];
    [searchField typeText:@"five\n"]; //Add five
    [backButton tap];
    [searchField tap];
    [searchField typeText:@"six"];
    [app.navigationBars.buttons[@"Search"] tap]; //Test search by uibarbuttonitem search
    [backButton tap];
    [app.tables.cells.staticTexts[@"Two"] swipeLeft];
    [app.tables.buttons[@"Delete"] tap]; //delete Two
    [app.tables.cells.staticTexts[@"Three"] swipeLeft];
    [app.tables.buttons[@"Delete"] tap]; //Delete Three
    [app.tables.cells.staticTexts[@"Four"] swipeLeft];
    [app.tables.buttons[@"Delete"] tap]; //Delete Four
    [searchField tap];
    [searchField typeText:@"five"]; //Filter to show Five
    [app.tables.cells.staticTexts[@"Five"] swipeLeft]; //Swipe left on the filtered Five cell
    [app.tables.buttons[@"Delete"] tap]; //And delete it
    [app.navigationBars.buttons[@"Search"] tap]; //Keyboard still up, searchbar filled with text, pressing Search button on keyboard searches for Five again
    [backButton tap];
}

@end
