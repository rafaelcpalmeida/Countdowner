//
//  ViewController.swift
//  Countdowner
//
//  Created by Rafael Almeida on 06/09/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var countDownLabel: NSTextField!
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    var addedObserver: Bool = false
    var counter: Int = 1800
    
    let countdowner = Countdowner(counter: 1800)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = self.view.window {
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.floatingWindow)))
        } else {
            addedObserver = true
            self.addObserver(self, forKeyPath: "view.window", options: [.new, .initial], context: nil)
        }
        
        self.view.layer?.backgroundColor = NSColor.green
        
        _ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let window = self.view.window {
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.overlayWindow)))
        }
    }
    
    deinit {
        if addedObserver {
            self.removeObserver(self, forKeyPath: "view.window")
        }
    }
    
    @objc func update() {
        if (counter >= 0) {
            let countdownerDetails = self.countdowner.update(counter: counter)
            
            self.view.layer?.backgroundColor = countdownerDetails.color
            appDelegate.setWindow(widthSize: countdownerDetails.window.width, heightSize: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y)
            self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", countdownerDetails.minutes)):\(String(format: "%02d", countdownerDetails.seconds))")
            
            counter -= 1
        }
    }
}
