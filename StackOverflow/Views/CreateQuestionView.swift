//
//  CreateQuestionView.swift
//  StackItUp
//
//  Created by mcs on 3/11/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
class CreateQuestionView: UIView {

    weak var controller: UIViewController?
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Title"
        return label
    }()
    
    var titleTxtField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 10
        txtField.placeholder = "  Title of your question"   // TODO: better way to do this?
        return txtField
    }()
    
    var bodyLabel: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Body of question here"
        return lbl
    }()
    
    var bodyTxtField: UITextView = {
        let txtField = UITextView()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.font = UIFont.systemFont(ofSize: 18)
        txtField.layer.cornerRadius = 10
        return txtField
    }()
    
    var tagsLabel: UILabel = {
        var lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Tags"
        return lbl
    }()
    
    var tagsTextField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.backgroundColor = .white
        txtField.layer.cornerRadius = 5
        return txtField
    }()
    
    var submitButton: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .systemBlue
        btn.setTitle("Submit Question", for: .normal)
        btn.addTarget(self, action: #selector(createQuestion), for: .touchUpInside)
        return btn
    }()
    
    @objc func createQuestion() {
        // Ask about this design pattern
        guard let titleText = titleTxtField.text, titleText != "" else {
            let alert = UIAlertController(title: "Error", message: "Need a title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let bodyText = bodyTxtField.text, bodyText != "" else {
            let alert = UIAlertController(title: "Error", message: "Need a body", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let tagsText = tagsTextField.text, tagsText != "" else {
            let alert = UIAlertController(title: "Error", message: "Need at least one tag", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            controller?.present(alert, animated: true, completion: nil)
            return
        }
        
        if let url = URLBuilder.createQuestionURL() {
            print(url)
            
            let key = "key=KXri6b9pdb3XETF1TjaH3A(("
            let token = "&access_token=" + (UserDefaults.standard.string(forKey: "access_token") ?? "")
            let site = "&site=stackoverflow.com"
            let title = "&title=" + titleText.replacingOccurrences(of: " ", with: "%20")
            let body =  "&body=" + bodyText.replacingOccurrences(of: " ", with: "%20")
            let tags = "&tags=" + tagsText

            let data = (key + token + site + title + body + tags).data(using: .utf8)

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(titleLabel)
        addSubview(titleTxtField)
        addSubview(bodyLabel)
        addSubview(bodyTxtField)
        addSubview(tagsLabel)
        addSubview(tagsTextField)
        addSubview(submitButton)
        
        addContraints()
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            titleTxtField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTxtField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleTxtField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleTxtField.heightAnchor.constraint(equalToConstant: 35),
            
            bodyLabel.topAnchor.constraint(equalTo: titleTxtField.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            bodyTxtField.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 10),
            bodyTxtField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            bodyTxtField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bodyTxtField.heightAnchor.constraint(equalToConstant: 150),
            
            tagsLabel.topAnchor.constraint(equalTo: bodyTxtField.bottomAnchor, constant: 20),
            tagsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            tagsTextField.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 10),
            tagsTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tagsTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tagsTextField.heightAnchor.constraint(equalToConstant: 35),
            
            submitButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            submitButton.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            submitButton.widthAnchor.constraint(equalToConstant: 300),
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
