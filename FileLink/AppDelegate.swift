//
//  AppDelegate.swift
//  FileLink
//
//  Created by Mark McDonald on 4/16/19.
//  Copyright © 2019 Mark McDonald. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem!
    let defaults = UserDefaults.standard
    
    let ud = MMUserDefaults.init()
    
    //MARK: Outlets
    @IBOutlet var statusMenu: NSMenu!
    @IBOutlet var preferencesWindow: NSWindow!
    @IBOutlet weak var hideDockIconButton: NSButton!
    
    //MARK: Actions
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        let preferencesWindowController = NSWindowController(window: preferencesWindow)
        preferencesWindowController.showWindow(self)
        
        switch defaults.bool(forKey: "HideDockIcon") {
            case false:
                hideDockIconButton.state = .on
            case true:
                hideDockIconButton.state = .off
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func toggleDockIconDefault(_ sender: NSButton) {
        var showIconBool: Bool
        
        switch sender.state {
        case .on:
            showIconBool = false
        case .off:
            showIconBool = true
        default:
            showIconBool = false
        }
        
        defaults.set(showIconBool, forKey: "HideDockIcon")
    }
    
    @IBAction func toggleNotificationOnService(_ sender: NSButton) {
        switch sender.state {
        case .on:
            defaults.set(true, forKey: "NotificationOnService")
        case .off:
             defaults.set(false, forKey: "NotificationOnService")
        default:
             defaults.set(true, forKey: "NotificationOnService")
        }
    }
    
    @IBAction func toggleNotificationOnDrop(_ sender: NSButton) {
        switch sender.state {
        case .on:
            defaults.set(true, forKey: "NotificationOnDrag")
        case .off:
            defaults.set(false, forKey: "NotificationOnDrag")
        default:
            defaults.set(true, forKey: "NotificationOnDrag")
        }
    }
    
    
    //MARK: Initialization
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = statusMenu
        
        let icon = NSImage(named: NSImage.Name("statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.button?.image = icon
        NSRegisterServicesProvider(MMPathUtility(), NSServiceProviderName("FileLink"))
        
        //Set Initial Defaults, if needed
        ud.initializeDefaults()
        
        //apply the default dock icon state
        _ = toggleDockIcon_Way2(showIcon: defaults.bool(forKey: "HideDockIcon"))
        
        //Notifications
        let un = MMUserNotifications.init()
        un.requestAuthorization()
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //MARK: File Open Logic
    func application(_ sender: NSApplication, openFiles: [String]) {
        
        let pu = MMPathUtility.init()
        let pb = NSPasteboard.general
        let un = MMUserNotifications.init()
        
        var urls: [String] = []
        
        for file in openFiles {
            let url = pu.fullVolumeURLforPath(filePath: file)!
            urls.append(url)
        }
        let urlsString = urls.joined(separator: "\n")
        pb.clearContents()
        pb.setString(urlsString, forType: .string)
        
        if defaults.bool(forKey: "NotificationOnDrag") { un.displayNotification(numberOfItems: openFiles.count) }
    }
}

//MARK: Refactor to class
func toggleDockIcon_Way2(showIcon state: Bool) -> Bool {
    var result: Bool
    if state {
        result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
    }
    else {
        result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
    }
    return result
}
