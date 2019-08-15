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
    
    init(id: String, question: String, category: String, company: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.question = question
        self.category = category
        self.company = company
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(question: Question, newContent: String, newCompany: String, newCategory: String) {
        self.init(id: question.id, question: newContent, category: newCategory, company: newCompany, createdAt: question.createdAt, updatedAt: question.updatedAt)
    }
}

struct SingleQuestion: Codable {
    let category: String
    let company: String
    let question : String
    
    init(question: Question) {
        self.category = question.category
        self.company = question.company
        self.question = question.question
    }
}

struct Exam: Codable {
    let questions: [Question]
}
