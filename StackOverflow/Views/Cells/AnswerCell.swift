//
//  AnswerCell.swift
//  StackItUp
//
//  Created by mcs on 3/25/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class AnswerCell: UITableViewCell {
    
    let scoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()
    
    let votesLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "votes"
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 12)
        return lbl
    }()
    
    let checkMarkImg: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let answerTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(scoreLabel)
        addSubview(votesLabel)
        addSubview(checkMarkImg)
        addSubview(answerTextLabel)
        
        addConstraints()
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            scoreLabel.heightAnchor.constraint(equalToConstant: 50),
            scoreLabel.widthAnchor.constraint(equalToConstant: 40),
            
            votesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 5),
            votesLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            votesLabel.widthAnchor.constraint(equalTo: scoreLabel.widthAnchor),
            
            checkMarkImg.leadingAnchor.constraint(equalTo: votesLabel.leadingAnchor),
            checkMarkImg.topAnchor.constraint(equalTo: votesLabel.bottomAnchor, constant: 5),
            checkMarkImg.widthAnchor.constraint(equalTo: votesLabel.widthAnchor),
            checkMarkImg.heightAnchor.constraint(equalToConstant: 30),
            
            answerTextLabel.topAnchor.constraint(equalTo: scoreLabel.topAnchor),
            answerTextLabel.leadingAnchor.constraint(equalTo: scoreLabel.trailingAnchor, constant: 10),
            answerTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            answerTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
}
