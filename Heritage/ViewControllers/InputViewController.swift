//
//  InputViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

protocol InputViewControllerDelegate {
    func userAdd(newQuestion: Question)
}

class InputViewController: UIViewController {
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    var selectedCategoryIndex: Int!
    var categories: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCategorySegement()
    }
    
    private func setUpCategorySegement() {
        for (index, category) in categories.enumerated() {
            let uppercasedCategory = category.uppercased()
            guard index < categorySegment.numberOfSegments else {
                categorySegment.insertSegment(withTitle: uppercasedCategory, at: index, animated: false)
                continue
            }
            categorySegment.setTitle(uppercasedCategory, forSegmentAt: index)
        }
        categorySegment.selectedSegmentIndex = selectedCategoryIndex
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonTouched(_ sender: Any) {
        let question = self.questionTextView.text ?? ""
        let company = self.companyNameTextField.text ?? ""
        let selectedCategory = self.categories[categorySegment.selectedSegmentIndex]
        let newQuestion = NewQuestion(category: selectedCategory, company: company, question: question)
        guard let encodedNewQuestion = try? JSONEncoder().encode(newQuestion) else {
            return
        }
        Service.register(newQuestion: encodedNewQuestion)
        self.dismiss(animated: true, completion: nil)
    }
}


struct NewQuestion: Codable {
    let category: String
    let company: String
    let questions : [String]
    
    init(category: String, company: String, question: String) {
        self.category = category
        self.company = company
        self.questions = [question]
    }
}
