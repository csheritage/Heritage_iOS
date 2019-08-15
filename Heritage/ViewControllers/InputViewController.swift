//
//  InputViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

protocol InputViewControllerDelegate: NSObject {
    func userAddNewQuestion()
    func userEndModifyingQuestion()
}

class InputViewController: UIViewController {
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var completeButton: UIButton!
    
    weak var delegate: InputViewControllerDelegate?
    
    var selectedCategoryIndex: Int!
    var categories: [String]!
    var question: Question?
    var mode: InputMode = .new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureRecognizerToBackgroundView()
        setUpCategorySegement()
        setUpBasedOnMode()
    }
    
    private func addTapGestureRecognizerToBackgroundView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func backgroundViewTapped() {
        self.view.endEditing(true)
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
        self.categorySegment.selectedSegmentIndex = selectedCategoryIndex
    }
    
    private func setUpBasedOnMode() {
        guard let selectedQuestion = self.question, mode == .display else {
            return
        }
        self.completeButton.setTitle("수정", for: .normal)
        self.questionTextView.text = selectedQuestion.question
        self.questionTextView.isEditable = false
        self.companyNameTextField.text = selectedQuestion.company
        self.companyNameTextField.isEnabled = false
        self.categorySegment.isEnabled = false
    }
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func completeButtonTouched(_ sender: Any) {
        switch mode {
        case .new:
            sendNewQuestion()
        case .display:
            self.completeButton.setTitle("완료", for: .normal)
            self.mode = .modify
            activateInput()
        case .modify:
            modifyQuestion()
        }
    }
    
    private func activateInput() {
        self.questionTextView.isEditable = true
        self.companyNameTextField.isEnabled = true
        self.categorySegment.isEnabled = true
        self.companyNameTextField.textColor = .black
        self.questionTextView.textColor = .black
        
    }
    
    private func sendNewQuestion() {
        let question = self.questionTextView.text ?? ""
        let company = self.companyNameTextField.text ?? ""
        let selectedCategory = self.categories[categorySegment.selectedSegmentIndex]
        let newQuestion = NewQuestion(category: selectedCategory, company: company, question: question)
        Service.register(newQuestion: newQuestion) {
            self.delegate?.userAddNewQuestion()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func modifyQuestion() {
        guard let existingQuestion = self.question else {
            return
        }
        let updatingContent = self.questionTextView.text ?? ""
        let updatingCompany = self.companyNameTextField.text ?? ""
        let updatingCategory = categories[categorySegment.selectedSegmentIndex]
        let modifyingQuestion = Question(question: existingQuestion, newContent: updatingContent, newCompany: updatingCompany , newCategory: updatingCategory)
        Service.modify(question: modifyingQuestion) {
            self.delegate?.userEndModifyingQuestion()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
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

enum InputMode {
    case new
    case display
    case modify
}
