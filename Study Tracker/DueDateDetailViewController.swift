//
//  DueDateDetailViewController.swift
//  View for adding and editing due date items
//  Study Tracker
//
//  Created by wang on 23/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol DueDateDetailViewControllerDelegate: class {
    func dueDateDetailViewControllerDidCancel(_ controller: DueDateDetailViewController)
    func dueDateDetailViewController(_ controller: DueDateDetailViewController,
                               didFinishAdding item: ChecklistItem)

    func dueDateDetailViewController(_ controller: DueDateDetailViewController,
                                     didFinishEditing item: ChecklistItem)
}

class DueDateDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newDueDateTitle: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false
    
    let itemToEditTitle = "Edit Due Date Title"
    weak var delegate: DueDateDetailViewControllerDelegate?

    
    //called by UIKit when the view controller is loaded from the storyboard, but before it is shown on the screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make a instance vairable to receive data from previous view
        //if let: if no value (nil), then the code inside the if let block is skipped over.
        if let item = itemToEdit {
            
            //when itemToEdit is not nil, change the title in the navigation bar to “Edit Item”.
            title = itemToEditTitle
            newDueDateTitle.text = item.text
            doneBarButton.isEnabled = true
            
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    //function to make the keyboard automatically appears once the screen opens
    //on the Simulator, Press ⌘+K to bring it up.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newDueDateTitle.becomeFirstResponder()
    }
    
    
    //function after adding or editing
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = newDueDateTitle.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.dueDateDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = newDueDateTitle.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            
            delegate?.dueDateDetailViewController(self, didFinishAdding: item)
        }
    }
 
    //function cancel
    @IBAction func cancel() {
        delegate?.dueDateDetailViewControllerDidCancel(self)
    }
    
    //a "?" after the return type, so nil is allowed to return
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    //For user friendly: UITextField delegate methods
    //invoked every time the user changes the text, whether by tapping on the keyboard or by cut/paste.
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        //replace "if...else.." statement
        //also can use "doneBarButton.isEnabled = newText.length > 0"
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        newDueDateTitle.resignFirstResponder()
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView,
                               indentationLevelForRowAt: newIndexPath)
    }
    
    //set the date label format
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    //shwo date picker
    func showDatePicker() {
        datePickerVisible = true
        
        let indexPathDateRow = IndexPath(row: 1, section: 1)
        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        newDueDateTitle.resignFirstResponder()
        
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in /* do nothing */ }
        }
    }
}
