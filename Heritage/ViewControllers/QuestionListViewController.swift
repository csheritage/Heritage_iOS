//
//  QuestionTableViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class QuestionListViewController: UIViewController {
    static let identifier = "QuestionListViewController"
    private struct Constants {
        static let cellIdentifier = "questionCell"
    }
    
    var selectedCategoryIndex: Int!
    var categories: [String]!
    var questions: [Question]!

    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = categories[selectedCategoryIndex]
        self.questionTableView.dataSource = self
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
        self.present(inputViewController, animated: true, completion: nil)
    }
}

extension QuestionListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = self.questions?[indexPath.row].question
        cell.detailTextLabel?.text = self.questions?[indexPath.row].company
        return cell
    }
}
