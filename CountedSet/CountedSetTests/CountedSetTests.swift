//
//  CountedSetTests.swift
//  CountedSetTests
//
//  Created by Timothy J. Wood on 10/30/15.
//  Copyright © 2015 The Omni Group. All rights reserved.
//

import XCTest
@testable import CountedSet

class CountedSetTests: XCTestCase {
    
    var set:CountedSet<Int>!
    
    override func setUp() {
        super.setUp()
        
        set = CountedSet()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testEmpty() {
        XCTAssertTrue(set.isEmpty)
    }
    
    func testAdd10() {
        for i in 0..<10 {
            set.insert(i)
        }
        XCTAssertFalse(set.isEmpty)
        XCTAssertEqual(set.count, 10)
        
        for i in 0..<10 {
            XCTAssertTrue(set.contains(i))
        }

        XCTAssertFalse(set.contains(11))
    }
    
    func testAddNTimes() {
        for i in 0..<10 {
            for _ in 0..<i {
                set.insert(i)
            }
        }

        XCTAssertEqual(set.count, 0+9 + 1+8 + 2+7 + 3+6 + 4+5)
        
        for i in 0..<10 {
            if (i == 0) {
                XCTAssertFalse(set.contains(i))
            } else {
                XCTAssertTrue(set.contains(i))
            }
            XCTAssertTrue(set.count(i) == i)
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
