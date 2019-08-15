//
//  Service.swift
//  Heritage
//
//  Created by Daheen Lee on 15/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

typealias CategoryDataCompletionHandler = (CategoryData?, Error?) -> Void
typealias CategoryListCompletionHandler = (CategoryList?, Error?) -> Void
typealias ExamQuestionCompletionHandler = (Exam?, Error?) -> Void

class Service {
    
    static func retrieveAllCategories(completionHandler: @escaping CategoryListCompletionHandler) {
        guard let url = URL(string: HeritageAPI.urlForAllCategories) else {
            print("url creation error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("request error")
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                print("data error")
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            guard let parsedCategoryList = try? decoder.decode(CategoryList.self, from: data) else {
                print("json decoder error")
                completionHandler(nil, error)
                return
            }
            completionHandler(parsedCategoryList, nil)
        }
        task.resume()
        
    }
    
    static func retrieveQuestions(for category: String, completionHandler: @escaping CategoryDataCompletionHandler) {
        guard let url = URL(string: HeritageAPI.urlForQuestionsIn(category: category)) else {
            print("url creation error")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("request error")
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                print("data error")
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            guard let parsedCategoryData = try? decoder.decode(CategoryData.self, from: data) else {
                print("json decoder error")
                completionHandler(nil, error)
                return
            }
            completionHandler(parsedCategoryData, nil)
        }
        task.resume()
    }
    
    static func retrieveExamQuestions(category: String, completionHandler: @escaping ExamQuestionCompletionHandler) {
        guard let url = URL(string: HeritageAPI.urlForExam(category: category)) else {
            print("url creation error")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("request error")
                completionHandler(nil, error)
                return
            }
            guard let data = data else {
                print("data error")
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            guard let parsedExam = try? decoder.decode(Exam.self, from: data) else {
                print("json decoder error")
                completionHandler(nil, error)
                return
            }
            completionHandler(parsedExam, nil)
        }
        task.resume()
    }
    
    static func register(newQuestion: NewQuestion, completionHandler: @escaping () -> Void) {
        guard let encodedNewQuestion = try? JSONEncoder().encode(newQuestion) else {
            return
        }
        let questionPostURL = "\(HeritageAPI.baseURL)\(HeritageAPI.question)"
        guard let url = URL(string: questionPostURL) else {
            print("error - fail to create url instance")
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = encodedNewQuestion
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("request error")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                print("reponse error")
                return
            }
            completionHandler()
        }
        task.resume()
    }
    
    static func delete(question: Question, completionHandler: @escaping () -> Void) {
        let deleteURL = "\(HeritageAPI.urlForSingleQuestion)"
        var urlComponents = URLComponents(string: deleteURL)
        urlComponents?.queryItems = [URLQueryItem(name: "_id", value: question.id)]
        guard let finalURL = urlComponents?.url else {
            return
        }
        var request: URLRequest = URLRequest(url: finalURL)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("request error")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    print("reponse error")
                    return
            }
            completionHandler()
        }
        task.resume()
    }
    
    static func modify(question: Question, completionHandler: @escaping () -> Void) {
        let deleteURL = "\(HeritageAPI.urlForSingleQuestion)"
        var urlComponents = URLComponents(string: deleteURL)
        urlComponents?.queryItems = [URLQueryItem(name: "_id", value: question.id)]
        guard let finalURL = urlComponents?.url else {
            return
        }
        var request: URLRequest = URLRequest(url: finalURL)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let encodedQuestion = try? JSONEncoder().encode(SingleQuestion(question: question)) else {
            return
        }
        request.httpBody = encodedQuestion
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("request error")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    print("reponse error")
                    return
            }
            completionHandler()
        }
        task.resume()
    }
    
}



struct HeritageAPI {
    static let baseURL = "https://the-heritage.herokuapp.com/"
    static let allCategories = "categories"
    static let question = "heritage"
    static let exam = "exam"
    
    static var urlForSingleQuestion: String {
        return "\(baseURL)\(question)/"
    }
    
    static var urlForAllCategories: String {
        return "\(baseURL)\(allCategories)/"
    }
    
    static func urlForQuestionsIn(category: String) -> String {
        return "\(baseURL)\(category)"
    }
    
    static func urlForExam(category: String) -> String {
        return "\(baseURL)\(exam)/\(category)"
    }
}


