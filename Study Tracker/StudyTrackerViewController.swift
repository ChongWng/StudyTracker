//
//  StudyTrackerViewController.swift
//  View for due dates for each course
//  Study Tracker
//
//  Created by wang on 22/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit


class StudyTrackerViewController: UITableViewController, DueDateDetailViewControllerDelegate {
    
    // declare the data type
    var items: [ChecklistItem]
    // The "!" allows its value to be temporarily nil until viewDidLoad() happens.
    var course: Course!
    
    //init?(coder) for view controllers that are automatically loaded from a storyboard
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()    //instantiate the array
        super.init(coder: aDecoder)   //ensure the rest of the view controller is properly unfrozen from the storyboard
        loadDueDateItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = course.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        //return the number of rows
        return items.count
    }

    //table data source
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        // Configure the cell
        configureCheckmark(for: cell, with: item)
        configureText(for: cell, with: item)
    
        return cell
    }
    
    //toggle the checkmark on a row or not function
    //action for existing table cell
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {

            
            let item = items[indexPath.row]
            item.toggleChecked()
        
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveDueDateItems()
    }
    
    //swipe-to-delete function
    //When the “commit EditingStyle” method is present in your view controller (it comes from the table view data source), the table view will automatically enable swipe-to-delete.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveDueDateItems()
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
    
    //configure the label text to match with the state
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    //cancel adding and editing items function
    func dueDateDetailViewControllerDidCancel(_ controller: DueDateDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    //finish adding function
    func dueDateDetailViewController(_ controller: DueDateDetailViewController,
                                     didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dismiss(animated: true, completion: nil)
        saveDueDateItems()
    }
    
    //finish editing function
    func dueDateDetailViewController(_ controller: DueDateDetailViewController,
                                     didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        saveDueDateItems()
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
    
    //the full path to the Documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //construct the full path to the file that will store the checklist items
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("DueDates.plist")
    }
    
    //load data function
    func loadDueDateItems() {
        let path = dataFilePath()
        //first time, no file found
        if let data = try? Data(contentsOf: path) {
            //NSKeyedArchiver is a form of NSCoder that creates plist files, encodes the array and all the DueDates in it into some sort of binary data format that can be written to a file.
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "DueDates") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    
    //save data function
    func saveDueDateItems() {
        //Data is placed in an NSMutableData object, which will write itself to the file specified by dataFilePath().
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "DueDates")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
}
