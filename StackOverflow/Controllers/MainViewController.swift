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
            - show check for best answer
     */
    
    let loginView = LoginView()
    let mainView = MainView()
    
    let logo: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = #imageLiteral(resourceName: "stackoverflow")
        return imgView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginView
        navigationItem.titleView = logo
        
        loginView.controller = self
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
