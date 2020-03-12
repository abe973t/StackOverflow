//
//  ViewController.swift
//  StackOverflow
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

// swiftlint:disable trailing_whitespace
class ViewController: UIViewController {
    
    /**
     TODO:
        - Build UI on paper - implement - test - commit
        - Rename project to Debug_?
     */
    
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "StackOverflow"
        
        mainView.controller = self
        mainView.configureSearchBar()
        view = mainView
        
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(postQuestionScreen)), animated: true)
    }
    
    @objc func postQuestionScreen() {
        navigationController?.pushViewController(CreateQuestionVC(), animated: true)
    }
}
