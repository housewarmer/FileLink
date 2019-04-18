//
//  PreferencesViewController.swift
//  FileLink
//
//  Created by Mark McDonald on 4/18/19.
//  Copyright © 2019 Mark McDonald. All rights reserved.
//

import Foundation
import Cocoa

class PreferencesWindowDelegate: NSObject, NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        let d = UserDefaults.standard
        
        let showIconBool = d.bool(forKey: "HideDockIcon")
        _ = toggleDockIcon_Way2(showIcon: showIconBool)
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        return true
    }
    
    func windowDidMove(_ notification: Notification) {
        //print(notification)
    }
}
