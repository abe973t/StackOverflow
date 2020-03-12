//
//  MainView.swift
//  StackOverflow
//
//  Created by mcs on 2/27/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import SafariServices

// swiftlint:disable trailing_whitespace
// swiftlint:disable line_length
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
        searchController!.searchBar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchBarView.addSubview(searchController!.searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
//        if let url = URLBuilder.accessTokenURL(clientID: 1733, clientSecret: "QZ6HBfR4qutoXsBLvZS2oA((", redirectURI: "https://stackexchange.com/oauth/login_success") {
//
//            NetworkManager.shared.post(url: url, data: nil) { (data, err) in
//                if err == nil {
//                    print(String(decoding: data!, as: UTF8.self))
//                }
//            }
//        }
        
        if let text = searchController.searchBar.text, !text.isEmpty {
            if let url = URLBuilder.searchQuestion(
                containing: text,
                sortedBy: .activity,
                displayOrder: .desc) {
                print(url)
                NetworkManager.shared.get(url: url) { (data, error) in
                    // add the shits here
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
            let safariVC = SFSafariViewController(url: questionURL)
            controller?.navigationController?.pushViewController(safariVC, animated: true)
        }
    }
}

extension MainView: SFSafariViewControllerDelegate {
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
}
