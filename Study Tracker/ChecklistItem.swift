//
//  ChecklistItem.swift
//  Study Tracker
//
//  Created by wang on 23/05/17.
//  Copyright © 2017 Unitec. All rights reserved.
//

import Foundation

//the absolute minimum amount of stuff you need in order to make a new object
class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}

