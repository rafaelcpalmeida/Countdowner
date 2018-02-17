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
        setWindow(width: 200, height: 100, x: 25, y: 25)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func setWindow(width: Int, height: Int, x: Int, y: Int) {
        guard
            let window = NSApplication.shared.windows.first,
            let screenWidth = NSScreen.main?.frame.width else { return }
        let windowOrigin = CGPoint(x: screenWidth - CGFloat(width + x), y: CGFloat(y))
        let windowSize = CGSize(width: width, height: height)

        window.setFrame(NSRect(origin: windowOrigin, size: windowSize), display: true)
    }
}
