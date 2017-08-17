//
//  AllCoursesViewController.swift
//  View for all courses
//  Study Tracker
//
//  Created by wang on 25/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class AllCoursesViewController: UITableViewController, CourseDetailViewControllerDelegate {
    
    var dataModel: DataModel! //once dataModel is given a value, it will never become nil again

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataModel.courses.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Course", for: indexPath)
        let course = dataModel.courses[indexPath.row]
        cell.textLabel!.text = course.name
        cell.accessoryType = .detailDisclosureButton
        
        
        // Configure the cell
//        configureText(for: cell, with: course)

        let count = course.countUncheckedItems()
        if course.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        return cell
    }

    //configure the label text to match with the state
    func configureText(for cell: UITableViewCell,
                       with course: Course) {
        let label = cell.viewWithTag(1010) as! UILabel
        label.text = course.name
    }
    
    //swipe-to-delete function
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.courses.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let course = dataModel.courses[indexPath.row]
        //send course object
        performSegue(withIdentifier: "ShowCourseDueDate", sender: course)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //from view controller to another view controller
        if segue.identifier == "ShowCourseDueDate" {
            let controller = segue.destination as! StudyTrackerViewController
            controller.course = sender as! Course
        } else if segue.identifier == "AddCourse" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! CourseDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditCourse" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! CourseDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath( for: sender as! UITableViewCell) {
                controller.courseToEdit = dataModel.courses[indexPath.row]
            }
        }
    }
    
    func courseDetailViewControllerDidCancel(
        _ controller: CourseDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func courseDetailViewController(_ controller: CourseDetailViewController,
                                  didFinishAdding course: Course) {
        let newRowIndex = dataModel.courses.count
        dataModel.courses.append(course)
        //dataModel.saveCourseDueDates()
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func courseDetailViewController(_ controller: CourseDetailViewController,
                                  didFinishEditing course: Course) {
        if let index = dataModel.courses.index(of: course) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = course.name
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

}
