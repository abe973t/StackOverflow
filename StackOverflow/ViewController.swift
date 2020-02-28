//
//  ViewController.swift
//  StackOverflow
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
class ViewController: UIViewController {
    
    /**
     TODO:
        - Build URL Builder - test - commit
        - Build Models - test - commit
        - Build UI on paper - implement - test - commit
     */
    
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.controller = self
        view = mainView
        
        navigationController?.navigationBar.barTintColor = .black
        
        print(URLBuilder.searchQuestion(containing: "hello", sortedBy: .activity, displayOrder: .desc, tags: "swift", "iOS", "Xcode"))
    }
    
}
