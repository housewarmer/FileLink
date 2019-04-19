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
    
    //MARK: Outlets
    @IBOutlet var statusMenu: NSMenu!
    @IBOutlet var preferencesWindow: NSWindow!
    @IBOutlet weak var hideDockIconButton: NSButton!
    
    //MARK: Actions
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        //let pvc = PreferencesViewController(window: preferencesWindow)
        let preferencesWindowController = NSWindowController(window: preferencesWindow)
        preferencesWindowController.showWindow(self)
        
        let defaults = UserDefaults.standard
        
        switch defaults.bool(forKey: "HideDockIcon") {
            case false:
                hideDockIconButton.state = .on
            case true:
                hideDockIconButton.state = .off
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func toggleDockIconDefault(_ sender: NSButton) {
        let defaults = UserDefaults.standard
        
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
        //_ = toggleDockIcon_Way2(showIcon: showIconBool)
    
    }
    
    
//    @IBAction func copyFileLink(_ sender: Any) {
//
//    }
    
    //MARK: Initialization
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.menu = statusMenu
        
        let icon = NSImage(named: NSImage.Name("statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.button?.image = icon
        NSRegisterServicesProvider(MMPathUtility(), NSServiceProviderName("FileLink"))
        
        //Set Initial Defaults
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "HideDockIcon") == nil {
            defaults.set(false, forKey: "HideDockIcon")
            print("created the key")
        }
        
        //apply the defaults
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
        print(urlsString)
        pb.clearContents()
        pb.setString(urlsString, forType: .string)
        
        un.displayNotification(numberOfItems: openFiles.count)
    }
}

//MARK: Refactor to class
func toggleDockIcon_Way2(showIcon state: Bool) -> Bool {
    print(state)
    var result: Bool
    if state {
        result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.regular)
    }
    else {
        result = NSApp.setActivationPolicy(NSApplication.ActivationPolicy.accessory)
    }
    return result
}
