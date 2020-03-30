//
//  FavoriteView.swift
//  StackItUp
//
//  Created by mcs on 3/29/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import SafariServices

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
        if let questionLink = favoriteQuestions![indexPath.row].url, let quesURL = URL(string: questionLink) {
            controller?.navigationController?.pushViewController(SFSafariViewController(url: quesURL), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
