//
//  Service.swift
//  Heritage
//
//  Created by Daheen Lee on 15/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import Foundation

typealias CategoryDataCompletionHandler = (CategoryData?, Error?) -> Void

class Service {
    static let quetionGetURL = "https://the-heritage.herokuapp.com/"
    static let questionPostURL = "https://the-heritage.herokuapp.com/heritage"
    static let categoriesGetURL = "https://the-heritage.herokuapp.com/categories"
    
    static func retrieveQuestions(for course: String, completionHandler: @escaping CategoryDataCompletionHandler) {
        guard let url = URL(string: "\(quetionGetURL)\(course)") else {
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
    
    static func register(newQuestion: Data) {
        guard let url = URL(string: questionPostURL) else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = newQuestion
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("request error")
                return
            }
            guard let data = data else {
                print("data error")
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: [])  {
                print(json)
                return
            }
        }
        task.resume()
        
    }
}

