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
        - Store authToken in UserDefaults (if you need a new one everytime) else CoreData
        - Finish create Question screen
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
        print("yo")
        mainView.controller = self
        mainView.configureSearchBar()
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(postQuestionScreen)), animated: true)
        
        view = mainView
    }
}
