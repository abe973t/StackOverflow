//
//  StackOverflowTests.swift
//  StackOverflowTests
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import XCTest
@testable import StackItUp

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
class StackOverflowTests: XCTestCase {
    
    let viewController = MainViewController()
    let questionViewController = QuestionViewController()
    let createQuestionViewController = CreateQuestionVC()
    let favQuesVC = FavoritesViewController()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewControllerMVVM() {
        XCTAssertNotNil(viewController.loginView)
        viewController.viewDidLoad()
        XCTAssertNotNil(viewController.loginView.controller)
    }
    
    func testQuestionVCMVVM() {
        XCTAssertNotNil(questionViewController.questionView)
        questionViewController.viewDidLoad()
        XCTAssertNotNil(questionViewController.questionView.controller)
    }
    
    func testFavQuestionVCMVVM() {
        XCTAssertNotNil(favQuesVC.favoritesView)
        favQuesVC.viewDidLoad()
        XCTAssertNotNil(favQuesVC.favoritesView.controller)
    }
    
    func testCreateQuestionVCMVVM() {
        XCTAssertNotNil(createQuestionViewController.createQuestionView)
        createQuestionViewController.viewDidLoad()
        XCTAssertNotNil(createQuestionViewController.createQuestionView.controller)
    }
    
    func testSearchQuestionsURL() throws {
        let url = try XCTUnwrap(URLBuilder.searchQuestion(containing: "hello", sortedBy: .activity, displayOrder: .desc, tags: "swift", "iOS", "Xcode"))
        
        XCTAssertEqual(url.absoluteString, "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=swift;iOS;Xcode&intitle=hello&site=stackoverflow")
        XCTAssertNotEqual(url.absoluteString, "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&tagged=swift,iOS,Xcode&intitle=hello&site=stackoverflow")
    }
    
    func testCreateQuestionsURL() throws {
        let url = try XCTUnwrap(URLBuilder.createQuestionURL)
        
        XCTAssertEqual(url()!.absoluteString, "https://api.stackexchange.com/2.2/questions/add/")
    }
    
    func testDecoding() throws {
        let jsonPath = try XCTUnwrap(Bundle.main.path(forResource: "QuestionJSON", ofType: "json"))
        let jsonPathURL = URL(fileURLWithPath: jsonPath)
        let jsonData = try Data(contentsOf: jsonPathURL)
        
        XCTAssertNoThrow(try JSONDecoder().decode(Question.self, from: jsonData))
    }

    func testAPIPerformance() {
        let semaphore = DispatchSemaphore(value: 0)
        
        if let url = URLBuilder.searchQuestion(
            containing: "UITableview",
            sortedBy: .activity,
            displayOrder: .desc) {
            NetworkManager.shared.get(url: url) { (data, error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
                
                semaphore.signal()
            }
        }
        
        if semaphore.wait(timeout: DispatchTime.now() + .seconds(3)) == .timedOut {
          XCTFail("This bit timed out")
        }
    }
}
