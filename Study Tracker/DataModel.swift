//
//  DataModel.swift
//  Study Tracker
//
//  Created by wang on 27/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation

class DataModel {
    var courses = [Course]()
    
    init() {
        loadCourseDueDates()
    }
    
    //the full path to the Documents folder
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //construct the full path to the file that will store the checklist items
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("CourseDueDates.plist")
    }
    
    //save data function
    func saveCourseDueDates() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(courses, forKey: "CourseDueDates")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    //load data function
    func loadCourseDueDates() {
        let path = dataFilePath()
        //first time, no file found
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            courses = unarchiver.decodeObject(forKey: "CourseDueDates") as! [Course]
            unarchiver.finishDecoding()
        }
    }
    
    //set default item ID
    func registerDefaults() {
        let dictionary: [String: Any] = ["ChecklistItemID": 0 ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    //set item ID
    //Adding the class keyword means that you can call this method without having a reference to the DataModel object.
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
}

