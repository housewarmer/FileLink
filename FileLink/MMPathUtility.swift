//
//  MMPathUtility.swift
//  FileLink
//
//  Created by Mark McDonald on 4/16/19.
//  Copyright © 2019 Mark McDonald. All rights reserved.
//

import Foundation
import Cocoa

struct ResourceError : Error {
    enum ErrorKind {
        case missingResource
    }
    let kind: ErrorKind
    let errorMessage: String
    
}

class MMPathUtility: NSObject {
    
    func fullVolumeURLForPath(fileURL: URL, percentEncoded: Bool = false) throws -> String? {
        let fullPathComponents = fileURL.pathComponents
        
        if fullPathComponents[1] != "Volumes" {
            if percentEncoded == false { return String(describing: fileURL) }
            else {return String(describing: fileURL).addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)!}
        }
        
        let len = fullPathComponents.count
        let pathComponents = fullPathComponents[3...len-1]
        let joindPathComponents = pathComponents.joined(separator: "/")
        
        let urlResources = try? fileURL.resourceValues(forKeys: [URLResourceKey.volumeURLForRemountingKey])
        if urlResources == nil { throw ResourceError(kind: .missingResource, errorMessage: "Error: Resource not found") }
        
        let volumeURL = urlResources?.volumeURLForRemounting
        
        let composedURLString: String?
        
        if volumeURL != nil {
            composedURLString = volumeURL!.scheme! + "://" + volumeURL!.host!  + volumeURL!.path + "/" + joindPathComponents
        }
        else {
            composedURLString = String(describing: fileURL)
        }
        
        if percentEncoded == false { return composedURLString! }
        else {return composedURLString!.addingPercentEncoding(withAllowedCharacters:.urlFragmentAllowed)!}
    }
    
    @objc func getRemoteURL(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        let pboardItems = pboard.pasteboardItems
        var processedURLs: [String] = []
        
        if #available(OSX 10.13, *) {
            for pi in pboardItems! {
                let pboardString = pi.string(forType: NSPasteboard.PasteboardType.fileURL)
                let pboardURL = URL(string: pboardString!)
                let processedURL = try? fullVolumeURLForPath(fileURL: pboardURL!, percentEncoded: true)!
                processedURLs.append(processedURL!)
            }
        } else {
            let NSFilenamesPboardTypeTemp = NSPasteboard.PasteboardType(kUTTypeFileURL as String)
            for pi in pboardItems! {
                let pboardString = pi.string(forType: NSFilenamesPboardTypeTemp)
                let pboardURL = URL(string: pboardString!)
                let processedURL = try? fullVolumeURLForPath(fileURL: pboardURL!, percentEncoded: true)!
                processedURLs.append(processedURL!)
            }
        }
        let urlStrings = processedURLs.joined(separator: "\n")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(urlStrings, forType: .string)
        
    }
}
