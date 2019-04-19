//
//  MMUserDefaults.swift
//  FileLink
//
//  Created by Mark McDonald on 4/19/19.
//  Copyright © 2019 Mark McDonald. All rights reserved.
//

import Foundation
import Cocoa


class MMUserDefaults: NSObject {
    
    let defaults = UserDefaults.standard
    let initialDefaultValues = [
        //App Mode prefs
        "HideDockItem": false,
        
        //Notification Prefs
        "NotificationOnDrop": true,
        "NotificationOnService": true,
    ]
    
    func initializeDefaults() -> Void {
        for dv in initialDefaultValues {
            if defaults.object(forKey: dv.key) == nil {
                defaults.set(dv.value, forKey: dv.key)
                print(defaults.object(forKey: dv.key)!)
            }
        }
    }
}
