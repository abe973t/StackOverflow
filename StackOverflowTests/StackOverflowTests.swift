//
//  StackOverflowTests.swift
//  StackOverflowTests
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import XCTest
@testable import StackOverflow

// swiftlint:disable trailing_whitespace
class StackOverflowTests: XCTestCase {
    
    let viewController = ViewController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewControllerMVVM() {
        XCTAssertNotNil(viewController.mainView)
        viewController.viewDidLoad()
        XCTAssertNotNil(viewController.mainView.controller)
    }
    
    func testURLBuilder() {
//        let url = urlbu
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
