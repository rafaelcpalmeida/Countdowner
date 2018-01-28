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
    var alert: Double = 0
    var danger: Double = 0
    
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
        
        self.alert = Double(counter) * 0.33
        self.danger = Double(counter) * 0.17
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
        if(counter >= 0) {
            let minutes = counter / 60
            let seconds = counter % 60
            
            if danger ... alert ~= Double(counter) {
                appDelegate.setWindow(widthSize: 300, heightSize: 200, x: 50, y: 50)
                self.view.layer?.backgroundColor = NSColor.yellow
            } else if 0 ... danger ~= Double(counter) {
                appDelegate.setWindow(widthSize: 400, heightSize: 300, x: 75, y: 75)
                self.view.layer?.backgroundColor = NSColor.red
            }
            
            self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
            
            counter -= 1
        }
    }
}

extension NSColor {
    static var green = NSColor(red:0.30, green:0.69, blue:0.31, alpha:1.0).cgColor
    static var yellow = NSColor(red:1.00, green:0.92, blue:0.23, alpha:1.0).cgColor
    static var red = NSColor(red:0.96, green:0.26, blue:0.21, alpha:1.0).cgColor
}
