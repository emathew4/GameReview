//
//  GameReviewerTests.swift
//  GameReviewerTests
//
//  Created by Ethan Mathew on 11/4/17.
//  Copyright © 2017 Ethan Mathew. All rights reserved.
//

import XCTest
@testable import GameReviewer

class GameReviewerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: Game Class Tests
    
    func testGameInitializationSucceeds() {
        let zeroRatingGame = Game.init(name: "Zero", photo: nil, rating:0)
        XCTAssertNotNil(zeroRatingGame)
        
        let positiveRatingGame = Game.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingGame)
    }
    
    func testGameInitializationFails() {
        let negativeRatingGame = Game.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingGame)
        
        let largeRatingGame = Game.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingGame)
        
        let emptyStringGame = Game.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringGame)
    }
    
}
