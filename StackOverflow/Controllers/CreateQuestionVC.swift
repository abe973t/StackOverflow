//
//  CreateQuestionVC.swift
//  StackItUp
//
//  Created by mcs on 3/11/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class CreateQuestionVC: UIViewController {
    
    let createQuestionView = CreateQuestionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Ask a Question"
        createQuestionView.controller = self
        view = createQuestionView
        view.backgroundColor = .systemGray
    }
}
