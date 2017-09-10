//
//  AppDelegate.swift
//  Countdowner
//
//  Created by Rafael Almeida on 06/09/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let window = NSApplication.shared().windows.first {
            let widthSize = 200
            let heightSize = 100
            
            let windowOriginPoint = CGPoint(x: (NSScreen.main()?.frame.width)! - CGFloat((widthSize + 25)), y: 25)
            let windowSize = CGSize(width: widthSize, height: heightSize)
            
            window.setFrame(NSRect(origin: windowOriginPoint, size: windowSize), display: true)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

