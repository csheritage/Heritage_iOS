//
//  CourseTableViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit
import KRProgressHUD

class CategoryTableViewController: UITableViewController {
    private struct Constants {
        static let title = "Heritage"
        static let cellIdentifier = "courseCell"
        static let segueIdentifierToQuestionList = "goToQuestionList"
        static let segueIdentifierToExam = "goToExamViewController"
    }
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.title
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks , target: self, action: #selector(examButtonTapped))
        getAllCategories()
    }
    
    @objc func examButtonTapped() {
        print("exam")
        performSegue(withIdentifier: Constants.segueIdentifierToExam, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let examViewController = segue.destination as? ExamRequestViewController else {
            return
        }
        examViewController.categories = self.categories
    }
    private func getAllCategories() {
        KRProgressHUD.show()
        Service.retrieveAllCategories { (categoryList, error) in
            guard let list = categoryList, error == nil else {
                print(error.debugDescription)
                return
            }
            self.categories = list.categories
            
            DispatchQueue.main.async {
                KRProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        KRProgressHUD.show()
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
                KRProgressHUD.dismiss()
                self.navigationController?.pushViewController(questionListViewController, animated: true)
            }
        }
    }
}
