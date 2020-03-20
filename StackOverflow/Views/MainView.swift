//
//  MainView.swift
//  StackOverflow
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
import SwiftSoup

// swiftlint:disable trailing_whitespace
class MainView: UIView {
    
    weak var controller: UIViewController?
    var searchController: UISearchController?
    var questionsList = [Question]()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.backgroundColor = .gray
        return tblView
    }()
    
    let searchBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        addViews()        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(searchBarView)
        addSubview(tableView)
        
        addContraints()
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBarView.heightAnchor.constraint(equalToConstant: 55),
            
            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension MainView: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController!.searchResultsUpdater = self
        searchController!.hidesNavigationBarDuringPresentation = false
        searchController!.automaticallyShowsCancelButton = false
        searchController!.delegate = self
        searchController!.searchBar.searchBarStyle = .minimal
        searchController!.searchBar.sizeToFit()
        searchController!.searchBar.becomeFirstResponder()
        searchController!.searchBar.showsCancelButton = true
        searchController!.searchBar.delegate = self
        searchController!.searchBar.barStyle = .black
        searchController!.searchBar.showsCancelButton = false
        
        searchBarView.addSubview(searchController!.searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            if let url = URLBuilder.searchQuestion(
                containing: text,
                sortedBy: .activity,
                displayOrder: .desc) {
                NetworkManager.shared.get(url: url) { (data, error) in
                    if let data = data {
                        do {
                            let response = try JSONDecoder().decode(SOResponse.self, from: data)
                            self.questionsList = response.items ?? []
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}

extension MainView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        // TODO: fix Fatal error - Index out of range
        cell?.textLabel?.text = self.questionsList[indexPath.row].title!
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let questionLink = questionsList[indexPath.row].link, let questionURL = URL(string: questionLink), let questionTitle = questionsList[indexPath.row].title {
            let qVC = QuestionViewController()
            qVC.title = questionTitle
                        
            let task = URLSession.shared.dataTask(with: questionURL) { data, response, error in
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
                    
                    var answers = [NSAttributedString]()
                    for answer in answersHTML.array() {
                        let answerString = NSString(string: answer.description).data(using: String.Encoding.utf8.rawValue)
                        let options = [
                            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html
                        ]
                        let answerAttributedString = try! NSMutableAttributedString(data: answerString!, options: options, documentAttributes: nil)
                        answers.append(answerAttributedString)
                    }
                    
                    DispatchQueue.main.async {
                        qVC.questionView.questionLabel.attributedText = attributedString
                        qVC.questionView.questionLabel.sizeToFit()
                        print(qVC.questionView.questionLabel.frame.height)
                        qVC.questionView.answers = answers
                        qVC.questionView.answersTableView.reloadData()
//                        qVC.questionView.scrollView.contentSize = CGSize(width: self.frame.width, height: qVC.questionView.questionLabel.frame.height + qVC.questionView.answersTableView.frame.height)
                        print(qVC.questionView.scrollView.contentSize.height)
                        qVC.questionView.scrollView.backgroundColor = .yellow
                        self.controller?.navigationController?.pushViewController(qVC, animated: true)
                    }
                } catch Exception.Error( _, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }

            task.resume()
        }
    }
}
