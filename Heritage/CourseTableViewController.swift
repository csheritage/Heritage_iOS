//
//  CourseTableViewController.swift
//  Heritage
//
//  Created by Daheen Lee on 14/08/2019.
//  Copyright © 2019 allwhite. All rights reserved.
//

import UIKit

class CourseTableViewController: UITableViewController {
    struct Constants {
        static let title = "Course"
        static let cellIdentifier = "courseCell"
    }
    var courseList = ["iOS", "Frontend", "Backend"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = courseList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: Constants.nextSceneSegueIdentifier, sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedCell = sender as? UITableViewCell,
            let questionListViewController = segue.destination as? QuestionListViewController else {
                return
        }
        questionListViewController.course = selectedCell.textLabel?.text
    }

}
