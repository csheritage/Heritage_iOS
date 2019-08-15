//
//  ExamPageViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 15/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class ExamPageViewController: UIViewController {
    var questions: [Question]!
    var currentIndex = 0
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryLabel.text = questions[0].category.uppercased()
        self.questionTextView.text = questions[currentIndex].question
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        currentIndex = currentIndex < questions.count - 1 ? currentIndex + 1 : currentIndex
        if currentIndex == questions.count - 1 {
            self.nextButton.isEnabled = false
            self.nextButton.setTitleColor(.gray, for: .normal)
        }
        self.questionTextView.text = questions[currentIndex].question
    }
    
    @IBAction func stopButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
