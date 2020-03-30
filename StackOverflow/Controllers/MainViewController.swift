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
            - login flow, encrypt pw
     */
    
    let loginView = LoginView()
    let mainView = MainView()
    let child = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginView
        title = "StackOverflow"
        
        loginView.controller = self
    }
    
    func loadMainScreen() {
        let addQuestionButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(postQuestionScreen))
        let accessFavButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(postFavoritesScreen))
        
        mainView.controller = self
        mainView.configureSearchBar()
        navigationItem.setRightBarButtonItems([addQuestionButton, accessFavButton], animated: true)
        
        view = mainView
    }
    
    func createSpinnerView() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        DispatchQueue.main.async {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
}

@objc extension MainViewController {
    func postQuestionScreen() {
        navigationController?.pushViewController(CreateQuestionVC(), animated: true)
    }
    
    func postFavoritesScreen() {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
}
