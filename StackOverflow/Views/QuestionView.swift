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
    
    var answers: [NSAttributedString]?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return view
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
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionLabel)
        contentView.addSubview(upArrowButton)
        contentView.addSubview(downArrowButton)
        contentView.addSubview(favButton)
//        scrollView.addSubview(answersCountLabel)
//        addSubview(sortSegmentedControl)
        contentView.addSubview(answersTableView)
//        addSubview(postAnswerTextfield)
//        addSubview(postButton)
        
        addConstraints()
//        questionLabel.sizeToFit()
//        scrollView.contentSize = CGSize(width: frame.width, height: questionLabel.frame.height + 75)
//        scrollView.isScrollEnabled = true
//        scrollView.showsVerticalScrollIndicator = true
    }
    
    func addConstraints() {
        let viewYAnchorConstraint = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        viewYAnchorConstraint.priority = UILayoutPriority(250)
        
        let viewBtmConstraint = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        viewBtmConstraint.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewBtmConstraint,
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            viewYAnchorConstraint,
            
            upArrowButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
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
            
            answersTableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor),
            answersTableView.leadingAnchor.constraint(equalTo: upArrowButton.leadingAnchor),
            answersTableView.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            answersTableView.heightAnchor.constraint(equalToConstant: 200),
            answersTableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
        ])
    }
}

extension QuestionView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.attributedText = answers?[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
