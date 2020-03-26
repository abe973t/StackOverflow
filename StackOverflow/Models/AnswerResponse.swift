//
//  Answer.swift
//  StackItUp
//
//  Created by mcs on 3/25/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct AnswerResponse: Codable {
    let items : [Answer]?
    let has_more : Bool?
    let quota_max : Int?
    let quota_remaining : Int?
}

struct Answer: Codable {
    let owner : Owner?
    let is_accepted : Bool?
    let score : Int?
    let last_activity_date : Int?
    let creation_date : Int?
    let answer_id : Int?
    let question_id : Int?
    var text: AttributedString?
}
 
