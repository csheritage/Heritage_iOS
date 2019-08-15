//
//  QuestionTableViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit
import KRProgressHUD

class QuestionListViewController: UIViewController {
    static let identifier = "QuestionListViewController"
    private struct Constants {
        static let cellIdentifier = "questionCell"
    }
    
    var selectedCategoryIndex: Int = 0
    var categories = [String]()
    var questions = [Question]()

    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categories[selectedCategoryIndex]
        self.questionTableView.dataSource = self
        self.questionTableView.delegate = self
        self.questionTableView.rowHeight = UITableView.automaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }
    
    @objc func addButtonTapped() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let inputViewController = mainStoryboard.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController else {
            return
        }
        inputViewController.categories = self.categories
        inputViewController.selectedCategoryIndex = self.selectedCategoryIndex
        inputViewController.delegate = self
        self.present(inputViewController, animated: true, completion: nil)
    }
}

extension QuestionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let question = self.questions[indexPath.row]
        cell.textLabel?.text = question.question
        cell.detailTextLabel?.text = question.company
        return cell
    }
}

extension QuestionListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedQuestion = questions[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let inputViewController = mainStoryboard.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController else {
            return
        }
        inputViewController.categories = self.categories
        inputViewController.selectedCategoryIndex = self.selectedCategoryIndex
        inputViewController.delegate = self
        inputViewController.question = selectedQuestion
        inputViewController.mode = .display
        self.present(inputViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            KRProgressHUD.show()
            Service.delete(question: questions[indexPath.row]) {
                KRProgressHUD.showSuccess()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.questions.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    KRProgressHUD.dismiss()
                }
            }
        }
    }
}


extension QuestionListViewController: InputViewControllerDelegate {
    func userAddNewQuestion() {
        updateQuestionTableData()
    }
    
    func userEndModifyingQuestion() {
        updateQuestionTableData()
    }
    
    private func updateQuestionTableData() {
        let currentCategory = categories[selectedCategoryIndex]
        KRProgressHUD.show()
        Service.retrieveQuestions(for: currentCategory) { (categoryData, error) in
            guard let data = categoryData, error == nil  else {
                print(error.debugDescription)
                return
            }
            self.questions = data.questions
            KRProgressHUD.showSuccess()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                KRProgressHUD.dismiss()
                self.questionTableView.reloadData()
            }
        }
    }
}
