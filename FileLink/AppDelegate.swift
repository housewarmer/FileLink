//
//  AppDelegate.swift
//  FileLink
//
//  Created by Mark McDonald on 4/16/19.
//  Copyright © 2019 Mark McDonald. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
   
    @IBOutlet var statusMenu: NSMenu!
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func copyFileLinkAction(_ sender: Any) {
        
    }
    
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = statusMenu
        
        let icon = NSImage(named: NSImage.Name("statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.button?.image = icon
        NSRegisterServicesProvider(MMPathUtility(), NSServiceProviderName("FileLink"))
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func application(openFiles: String) {
        print(openFiles)
    }
    
}

