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
    
    let mainView = MainView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.controller = self
        view = mainView
        
        navigationController?.navigationBar.barTintColor = .black
    }
    
}
