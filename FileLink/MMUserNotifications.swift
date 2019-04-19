//
//  MMUserNotifications.swift
//  FileLink
//
//  Created by Mark McDonald on 4/19/19.
//  Copyright © 2019 Mark McDonald. All rights reserved.
//

import Foundation
import UserNotifications

class MMUserNotifications: NSObject, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()
    
    
    //Request Authorization
    func requestAuthorization() {
        center.requestAuthorization(options: [.alert], completionHandler:authorizationCompletionHandler)
    }
    
    func authorizationCompletionHandler(granted: Bool, error: Error?) -> Void {
        //print(String(format: "Notifications authorization granted? %@",  [granted]))
        //print(error ?? "No authorization error. Nice.")
    }
    
    func displayNotification(numberOfItems: Int) {

        let title = ((numberOfItems > 1) ? "File Links Copied" : "File Link Copied")
        let body = ((numberOfItems > 1) ? "Links for \(numberOfItems) items copied to clipboard" : "Link for 1 item copied to clipboard")
        
        let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            content.badge = NSNumber(value: numberOfItems)
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            print(error ?? "No error, cool.")
        }
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
