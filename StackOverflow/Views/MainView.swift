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
                print(url)
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
        
        cell?.textLabel?.text = self.questionsList[indexPath.row].title!
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let questionLink = questionsList[indexPath.row].link, let questionURL = URL(string: questionLink) {
//        controller?.navigationController?.pushViewController(QuestionViewController(), animated: true)
            print(questionURL.absoluteString)
                        
            // use this to start the web scraping
            let task = URLSession.shared.dataTask(with: questionURL) { data, response, error in
                guard let data = data, error == nil else {
                    print("\(error)")
                    return
                }

                do {
                    let html = String(data: data, encoding: .utf8)
                    let doc: Document = try SwiftSoup.parse(html!)
                    let link: Elements = try doc.getElementsByClass("post-text")
                    
                    let text: String = try doc.body()!.text(); // "An example link"
                    let linkHref: String = try link.attr("href"); // "http://example.com/"
                    let linkText: String = try link.text(); // "example"
                    
                    let linkOuterH: String = try link.outerHtml(); // "<a href="http://example.com"><b>example</b></a>"
                    let linkInnerH: String = try link.html(); // "<b>example</b>"
                } catch Exception.Error(let type, let message) {
                    print(message)
                } catch {
                    print("error")
                }
            }

            task.resume()
        }
    }
}

extension MainView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteURL)
    }
}
