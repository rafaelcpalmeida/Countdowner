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
        setWindow(widthSize: 200, heightSize: 100, x: 25, y: 25)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func setWindow(widthSize: Int, heightSize: Int, x: Int, y: Int) {
        if let window = NSApplication.shared.windows.first {
            let windowOriginPoint = CGPoint(x: (NSScreen.main?.frame.width)! - CGFloat((widthSize + x)), y: CGFloat(y))
            let windowSize = CGSize(width: widthSize, height: heightSize)
            
            window.setFrame(NSRect(origin: windowOriginPoint, size: windowSize), display: true)
        }
    }
}

