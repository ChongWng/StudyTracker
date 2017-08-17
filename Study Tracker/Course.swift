//
//  course.swift
//  course items
//  Study Tracker
//
//  Created by wang on 25/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import UIKit

//NSCoding protocol requires two methods, init?(coder) and encode(with).
class Course: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init() //built on superclass NSObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Courses") as! [ChecklistItem]
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Courses")
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1 }
        return count
    }
}
