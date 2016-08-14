//
//  FlickrScrollerTests.m
//  FlickrScrollerTests
//
//  Created by Dhiraj Gupta on 8/13/16.
//  Copyright © 2016 Traversient Tech LLP. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlickrResult.h"
#import "BUtil.h"

@interface FlickrScrollerTests : XCTestCase

@end

@implementation FlickrScrollerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInvalidJSONObject {
    NSBundle * testBundle = [NSBundle bundleForClass:[self class]];
    NSURL * urlInvalidObject = [testBundle URLForResource:@"invalidflickrobject" withExtension:@"json"];
    NSData * invalidJSON = [NSData dataWithContentsOfURL:urlInvalidObject];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:invalidJSON options:0 error:nil];
    FlickrResult * result = [FlickrResult resultWithDictionary:dict];
    XCTAssertNil(result);
}
- (void)testValidJSONObject {
    NSBundle * testBundle = [NSBundle bundleForClass:[self class]];
    NSURL * urlInvalidObject = [testBundle URLForResource:@"validflickrobject" withExtension:@"json"];
    NSData * invalidJSON = [NSData dataWithContentsOfURL:urlInvalidObject];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:invalidJSON options:0 error:nil];
    FlickrResult * result = [FlickrResult resultWithDictionary:dict];
    XCTAssertNotNil(result);
    XCTAssertTrue([result.url_q isEqualToString:@"https://farm9.staticflickr.com/8477/28350483854_d5a7279e68_q.jpg"]);
}
- (void)testFlickrObjectArray {
    NSBundle * testBundle = [NSBundle bundleForClass:[self class]];
    NSURL * urlInvalidObject = [testBundle URLForResource:@"results30" withExtension:@"json"];
    NSData * invalidJSON = [NSData dataWithContentsOfURL:urlInvalidObject];
    NSArray * arr = [NSJSONSerialization JSONObjectWithData:invalidJSON options:0 error:nil];
    XCTAssertTrue([BUtil isValidArray:arr]);
    XCTAssertEqual(arr.count, 30);
    NSArray * arrResults = [FlickrResult resultsFromArrayOfDictionaries:arr];
    XCTAssertTrue([BUtil isValidArray:arrResults]);
    XCTAssertEqual(arrResults.count, 29); //One object doesn't have url_q
    id result = arrResults[0];
    XCTAssertTrue([result isKindOfClass:[FlickrResult class]]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
