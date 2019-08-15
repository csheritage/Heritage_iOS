//
//  CourseData.swift
//  Heritage
//
//  Created by Daheen Lee on 15/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

struct CategoryData: Codable {
    let questions: [Question]
}

struct Question: Codable {
    let id, question: String
    let category: String
    let company: String
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case question, category, company
        case createdAt = "created_at"
        case updatedAt
    }
}
