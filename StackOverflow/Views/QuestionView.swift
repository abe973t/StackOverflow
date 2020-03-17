//
//  QuestionView.swift
//  StackItUp
//
//  Created by mcs on 3/13/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class QuestionView: UIView {
    
    /*
     TODO:
        - entire pg in scrollView
        - tblView shouldn't scroll
        - quesLbl height should be dynamic
        - adjust color scheme
     **/
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let questionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.text = "Placeholder"
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    let upArrowButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "up-arrow"), for: .normal)
        return btn
    }()
    
    let downArrowButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "down-arrow"), for: .normal)
        return btn
    }()
    
    let favButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "star-2"), for: .normal)
        return btn
    }()
    
    let answersCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "X Answers"
        return lbl
    }()
    
    let sortSegmentedControl: UISegmentedControl = {
        let sgControl = UISegmentedControl(items: ["Active", "Oldest", "Votes"])
        sgControl.translatesAutoresizingMaskIntoConstraints = false
        return sgControl
    }()
    
    let answersTableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.backgroundColor = .gray
        return tblView
    }()
    
    let postAnswerTextfield: UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        return txtView
    }()

    let postButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Post Answer", for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(questionLabel)
        addSubview(upArrowButton)
        addSubview(downArrowButton)
        addSubview(favButton)
        addSubview(answersCountLabel)
        addSubview(sortSegmentedControl)
        addSubview(answersTableView)
        addSubview(postAnswerTextfield)
        addSubview(postButton)
        
        addConstraints()
        questionLabel.sizeToFit()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            upArrowButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            upArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            upArrowButton.heightAnchor.constraint(equalToConstant: 30),
            upArrowButton.widthAnchor.constraint(equalToConstant: 30),
            
            downArrowButton.topAnchor.constraint(equalTo: upArrowButton.bottomAnchor, constant: 20),
            downArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            downArrowButton.heightAnchor.constraint(equalToConstant: 30),
            downArrowButton.widthAnchor.constraint(equalToConstant: 30),
            
            favButton.topAnchor.constraint(equalTo: downArrowButton.bottomAnchor, constant: 20),
            favButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            favButton.widthAnchor.constraint(equalToConstant: 30),
            
            questionLabel.topAnchor.constraint(equalTo: upArrowButton.topAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: upArrowButton.trailingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
