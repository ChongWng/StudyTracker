//
//  CourseDetailViewController.swift
//  Study Tracker
//
//  Created by wang on 26/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation
import UIKit

protocol CourseDetailViewControllerDelegate: class {
    func courseDetailViewControllerDidCancel(_ controller: CourseDetailViewController)
    func courseDetailViewController(_ controller: CourseDetailViewController,
                                  didFinishAdding course: Course)
    func courseDetailViewController(_ controller: CourseDetailViewController,
                                  didFinishEditing course: Course)
}

class CourseDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    weak var delegate: CourseDetailViewControllerDelegate?
    var courseToEdit: Course?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let course = courseToEdit {
            title = "Edit Course"
            textField.text = course.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.courseDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let course = courseToEdit {
            course.name = textField.text!
            delegate?.courseDetailViewController(self, didFinishEditing: course)
        } else {
            let course = Course(name: textField.text!)
            delegate?.courseDetailViewController(self, didFinishAdding: course)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }  
}
