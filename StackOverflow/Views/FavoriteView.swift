//
//  FavoriteView.swift
//  StackItUp
//
//  Created by mcs on 3/29/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import SwiftSoup

class FavoriteView: UIView {
        
    weak var controller: FavoritesViewController?
    var favoriteQuestions: [FavQuestion]?
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        CoreDataDeleteOps.shared.deleteQuestion(ques: nil)
        
        addViews()
        favoriteQuestions = CoreDataFetchOps.shared.fetchQuestion()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(tableView)
        
        addContraints()
    }

    func addContraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}


extension FavoriteView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteQuestions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.favoriteQuestions![indexPath.row].title!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let questionLink = favoriteQuestions![indexPath.row].url, let questionURL = URL(string: questionLink), let questionTitle = favoriteQuestions![indexPath.row].title {
            let qVC = QuestionViewController()
            let questionID = favoriteQuestions![indexPath.row].quesID
            qVC.title = questionTitle
            
            self.controller?.createSpinnerView()
            var answers = [Answer]()
            let group = DispatchGroup()
            group.enter()
            URLSession.shared.dataTask(with: URLBuilder.fetchAnswersURL(questionID: Int(questionID), sorting: .activity)!) { data, response, error in
                if let data = data {
                    do {
                        let answersResponse = try JSONDecoder().decode(AnswerResponse.self, from: data)
                        answers = answersResponse.items ?? []
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                group.leave()
            }.resume()
            
            group.wait()
            group.enter()
            URLSession.shared.dataTask(with: questionURL) { data, response, error in
                guard let data = data, error == nil else {
                    print(error!.localizedDescription)
                    return
                }

                do {
                    let html = String(data: data, encoding: .utf8)
                    let doc: Document = try SwiftSoup.parse(html!)
                    let questionHTML: Elements = try doc.getElementsByClass("post-text")
                    let answersHTML: Elements = try doc.getElementsByClass("answercell post-layout--right")
                    let questionHTMLData = NSString(string: questionHTML.first()!.description).data(using: String.Encoding.utf8.rawValue)
                    let options = [
                        NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
                    ]
                    let attributedString = try! NSMutableAttributedString(data: questionHTMLData!, options: options, documentAttributes: nil)
                    attributedString.addAttributes([
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)
                    ], range: NSMakeRange(0, attributedString.length))
                    
                    for (index, answer) in answersHTML.array().enumerated() {
                        let answerString = NSString(string: answer.description).data(using: String.Encoding.utf8.rawValue)
                        let options = [
                            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
                        ]
                        let answerAttributedString = try! NSAttributedString(data: answerString!, options: options, documentAttributes: nil)
                        
                        if answers.count != answersHTML.count {
                            answers.append(Answer(owner: nil, is_accepted: nil, score: nil, last_activity_date: nil, creation_date: nil, answer_id: nil, question_id: nil, text: AttributedString(nsAttributedString: answerAttributedString)))
                        } else {
                            answers[index].text = AttributedString(nsAttributedString: answerAttributedString)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        let question = Question(tags: nil, owner: nil, is_answered: nil, view_count: nil, accepted_answer_id: nil, answer_count: nil, score: nil, last_activity_date: nil, creation_date: nil, last_edit_date: nil, question_id: Int(questionID), link: questionLink, title: questionTitle)
                        qVC.questionView.question = question
                        qVC.questionView.questionLabel.attributedText = attributedString
                        qVC.questionView.questionLabel.sizeToFit()
                        qVC.questionView.answersCountLabel.text = "\(answers.count) Answers"
                        
                        CoreDataFetchOps.shared.fetchQuestion().forEach { (favQues) in
                            if Int(favQues.quesID) == questionID {
                                qVC.questionView.favButton.setImage(#imageLiteral(resourceName: "star"), for: .normal)
                            }
                        }
                        
                        if answers.count == 0 {
                            qVC.questionView.answersTableView.isHidden = true
                        } else {
                            qVC.questionView.answers = answers
                            qVC.questionView.answersTableView.reloadData()
                        }
                        
                        self.controller?.navigationController?.pushViewController(qVC, animated: true)
                    }
                } catch Exception.Error( _, let message) {
                    print(message)
                } catch {
                    print("error")
                }
                group.leave()
            }.resume()
            group.notify(queue: .main) {
                self.controller?.removeSpinnerView()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
