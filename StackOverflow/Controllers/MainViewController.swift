//
//  ViewController.swift
//  StackOverflow
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

// swiftlint:disable trailing_whitespace
class MainViewController: UIViewController {
    
    /**
     TODO:
        - Store authToken in UserDefaults, encrypt somehow
        - Finish Question screen
            - parse question
            - parse answers
        - find cool sound to play when app loads and when you post shit
     */
    
    let loginView = LoginView()
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "StackOverflow"
        loginView.controller = self
        view = loginView
        navigationController?.navigationBar.barTintColor = .black
    }
    
    @objc func postQuestionScreen() {
        navigationController?.pushViewController(CreateQuestionVC(), animated: true)
    }
    
    func loadMainScreen() {
        mainView.controller = self
        mainView.configureSearchBar()
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(postQuestionScreen)), animated: true)
        
        view = mainView
    }
}
