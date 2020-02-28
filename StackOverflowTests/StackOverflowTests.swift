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
// swiftlint:disable line_length
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
    
    func testSearchQuestionsURL() throws {
        let url = try XCTUnwrap(URLBuilder.searchQuestion(containing: "hello", sortedBy: .activity, displayOrder: .desc, tags: "swift", "iOS", "Xcode"))
        
        XCTAssertEqual(url.absoluteString, "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=swift;iOS;Xcode&intitle=hello&site=stackoverflow")
        XCTAssertNotEqual(url.absoluteString, "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=swift,iOS,Xcode&intitle=hello&site=stackoverflow")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
