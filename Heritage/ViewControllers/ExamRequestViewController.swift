//
//  ExamViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 15/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class ExamRequestViewController: UIViewController {
    private let segueIdentifier = "goToExamPage"
    private var exam : Exam!
    @IBOutlet weak var categorySegment: UISegmentedControl!
    
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "모의 면접"
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
    }

    @IBAction func startButtonTouched(_ sender: Any) {
        let selectedCategory = categories[categorySegment.selectedSegmentIndex]
        Service.retrieveExamQuestions(category: selectedCategory) { (exam, error) in
            self.exam = exam
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: self.segueIdentifier, sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let examPageViewController = segue.destination as? ExamPageViewController else {
            return
        }
        examPageViewController.questions = exam.questions
    }
    

}
