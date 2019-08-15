//
//  CourseTableViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    private struct Constants {
        static let title = "Course"
        static let cellIdentifier = "courseCell"
        static let segueIdentifierToQuestionList = "goToQuestionList"
    }
    var categories = ["ios", "front", "back"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        Service.retrieveQuestions(for: selectedCategory) { (categoryData, error) in
            guard let data = categoryData, error == nil else {
                print(error.debugDescription)
                return
            }
            DispatchQueue.main.async {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                guard let questionListViewController = mainStoryBoard.instantiateViewController(withIdentifier: QuestionListViewController.identifier) as? QuestionListViewController else {
                    return
                }
                questionListViewController.categories = self.categories
                questionListViewController.selectedCategoryIndex = indexPath.row
                questionListViewController.questions = data.questions
                self.navigationController?.pushViewController(questionListViewController, animated: true)
            }
        }
    }
}
