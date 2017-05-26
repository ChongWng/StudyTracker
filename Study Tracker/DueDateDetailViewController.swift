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
    var itemToEdit: ChecklistItem?
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
        }
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
            delegate?.dueDateDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = newDueDateTitle.text!
            item.checked = false
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
        return nil
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
    
    
}
