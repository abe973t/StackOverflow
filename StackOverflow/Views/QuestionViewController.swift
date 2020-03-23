//
//  QuestionViewController.swift
//  StackItUp
//
//  Created by mcs on 3/13/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var questionView = QuestionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = questionView
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        DispatchQueue.main.async {
//            self.questionView.answersTableView.reloadData()
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        questionView.tableViewHeightConstraint!.constant = self.questionView.answersTableView.contentSize.height
        print(self.questionView.answersTableView.contentSize.height)
    }
}
