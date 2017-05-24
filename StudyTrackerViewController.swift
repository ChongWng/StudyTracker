//
//  StudyTrackerViewController.swift
//  Study Tracker
//
//  Created by wang on 22/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

class StudyTrackerViewController: UITableViewController, DueDateDetailViewControllerDelegate {
    
    // This declares that items will hold an array of ChecklistItem objects
    // but it does not actually create that array.    
    // It is just the data type of the items variable, it's a container for the real object
    var items: [ChecklistItem]
    
    required init?(coder aDecoder: NSCoder) {
        
        // This instantiates the array. Now items contains a valid array object,
        // but the array has no ChecklistItem objects inside it yet.
        items = [ChecklistItem]()
        
        // This instantiates a new ChecklistItem object. Notice the ().
        let row0item = ChecklistItem()
        // Give values to the data items inside the new ChecklistItem object.
        row0item.text = "7436 Assignment1 Check point1"
        row0item.checked = false
        // This adds the ChecklistItem object into the items array.
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "7420 Assignment1 Tutorial1"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "7421 Assignment1 Idea Demenstration"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "7444 Class Exercise"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "8038 Group Discussion"
        row4item.checked = true
        items.append(row4item)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    //table data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        // Configure the cell
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)
    
        return cell
    }
    

    //action for existing table cell
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {

            
            let item = items[indexPath.row]
            item.toggleChecked()
            

            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //When the “commitEditingStyle” method is present in your view controller (it comes from the table view data source), the table view will automatically enable swipe-to- delete. 
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
 
    //configure the checkmark to match with the state
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }


    func dueDateDetailViewControllerDidCancel(_ controller: DueDateDetailViewController) {
        dismiss(animated: true, completion: nil)
    }

    func dueDateDetailViewController(_ controller: DueDateDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    func dueDateDetailViewController(_controller: DueDateDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "AddDueDate" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! DueDateDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditDueDate"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! DueDateDetailViewController
            controller.delegate = self
            
            //data passing from A=>B
            //A puts an object into this property right before it makes screen B visible, usually in prepare(for:sender:).
            //then B simply make a new instance variable in view controller.
            if let indexPath = tableView.indexPath( for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}
