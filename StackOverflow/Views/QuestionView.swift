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
        - adjust color scheme
        - refresh pg after post answer
        - change alert when post successful
     **/
    
    weak var controller: UIViewController?
    var answers: [NSAttributedString]?
    var tableViewHeightConstraint: NSLayoutConstraint!
    var questionID: Int!
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    let sortSegmentedControl: UISegmentedControl = {
        let sgControl = UISegmentedControl(items: ["Active", "Oldest", "Votes"])
        sgControl.translatesAutoresizingMaskIntoConstraints = false
        sgControl.backgroundColor = .black
        sgControl.tintColor = .white
        sgControl.selectedSegmentIndex = 0
        return sgControl
    }()
    
    let answersTableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.layer.cornerRadius = 5
        tblView.backgroundColor = .gray
        return tblView
    }()
    
    let postAnswerTextfield: UITextView = {
        let txtView = UITextView()
        txtView.translatesAutoresizingMaskIntoConstraints = false
        txtView.layer.cornerRadius = 5
        return txtView
    }()

    let postButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .systemBlue
        btn.setTitle("Post Answer", for: .normal)
        btn.addTarget(self, action: #selector(postAnswer), for: .touchUpInside)
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
    
    @objc func postAnswer() {
        // Ask about this design pattern
        guard let answerText = postAnswerTextfield.text, answerText != "" else {
            let alert = UIAlertController(title: "Error", message: "Answer cannot be blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "access_token") else {
            let alert = UIAlertController(title: "Error", message: "Must have token stored somewhere", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            return
        }

        if let url = URLBuilder.createAnswerURL(questionID: questionID) {
            let key = "key=KXri6b9pdb3XETF1TjaH3A(("
            let tokenComponent = "&access_token=" + token
            let site = "&site=stackoverflow.com"
            let body =  "&body=" + answerText.replacingOccurrences(of: " ", with: "%20")

            let data = (key + tokenComponent + site + body).data(using: .utf8)

            NetworkManager.shared.post(url: url, data: data, completion: { (data, error) in
                var message = ""

                if error == nil {
                    message = String(decoding: data!, as: UTF8.self)
                } else {
                    message = error!.localizedDescription
                }

                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Response", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.controller?.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func addViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(questionLabel)
        contentView.addSubview(questionLabel)
        contentView.addSubview(upArrowButton)
        contentView.addSubview(downArrowButton)
        contentView.addSubview(favButton)
        contentView.addSubview(answersCountLabel)
        contentView.addSubview(sortSegmentedControl)
        contentView.addSubview(answersTableView)
        contentView.addSubview(postAnswerTextfield)
        contentView.addSubview(postButton)
        
        addConstraints()
    }
    
    func addConstraints() {
        let viewYAnchorConstraint = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        viewYAnchorConstraint.priority = UILayoutPriority(250)
        
        let viewBtmConstraint = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        viewBtmConstraint.priority = UILayoutPriority(250)
        
        tableViewHeightConstraint = answersTableView.heightAnchor.constraint(equalToConstant: 200)
        
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
            
            answersCountLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor),
            answersCountLabel.leadingAnchor.constraint(equalTo: upArrowButton.leadingAnchor),
            answersCountLabel.widthAnchor.constraint(equalToConstant: 75),
            answersCountLabel.heightAnchor.constraint(equalToConstant: sortSegmentedControl.frame.height),
            
            sortSegmentedControl.topAnchor.constraint(equalTo: answersCountLabel.topAnchor),
            sortSegmentedControl.leadingAnchor.constraint(equalTo: answersCountLabel.trailingAnchor, constant: 20),
            sortSegmentedControl.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            
            answersTableView.topAnchor.constraint(equalTo: answersCountLabel.bottomAnchor, constant: 20),
            answersTableView.leadingAnchor.constraint(equalTo: upArrowButton.leadingAnchor),
            answersTableView.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            tableViewHeightConstraint,
            
            postAnswerTextfield.topAnchor.constraint(equalTo: answersTableView.bottomAnchor, constant: 10),
            postAnswerTextfield.leadingAnchor.constraint(equalTo: upArrowButton.leadingAnchor),
            postAnswerTextfield.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            postAnswerTextfield.heightAnchor.constraint(equalToConstant: 100),
            
            postButton.topAnchor.constraint(equalTo: postAnswerTextfield.bottomAnchor, constant: 20),
            postButton.leadingAnchor.constraint(equalTo: upArrowButton.leadingAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 125),
            postButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50),
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
        return UITableView.automaticDimension
    }
}
