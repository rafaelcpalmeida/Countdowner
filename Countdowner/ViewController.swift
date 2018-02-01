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
    @IBOutlet weak var settingsButton: NSButton!
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let countdownerService = CountdownerServiceManager()
    
    var addedObserver: Bool = false
    var counter: Int = 0
    var countdownTimer: Timer? = nil
    var countdowner: Countdowner? = nil
    var runningTimer: Bool = false
    var preferences = Preferences()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultCounterValue()
        self.countdowner = Countdowner(counter: counter)
        self.setTime()
        self.view.layer?.backgroundColor = CGColor.green
        
        if let window = self.view.window {
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(CGWindowLevelKey.floatingWindow)))
        } else {
            addedObserver = true
            self.addObserver(self, forKeyPath: "view.window", options: [.new, .initial], context: nil)
        }
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
    
    override func mouseDown(with theEvent: NSEvent) {
        handleTimer()
    }
    
    override func rightMouseDown(with theEvent: NSEvent) {
        handleTimer()
    }
    
    @IBAction func settingsButton(_ sender: NSButton) {
        let alert = NSAlert()
        let secondsField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        
        secondsField.placeholderString = "30 minutes equals to 1800 seconds"
        secondsField.formatter = OnlyIntegerValueFormatter()
        
        alert.messageText = "Please insert the value, in seconds, of the timer:"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.accessoryView = secondsField
        
        if alert.runModal() == .alertFirstButtonReturn {
            if let seconds = Int(secondsField.stringValue) {
                if seconds > 0 {
                    self.preferences.counterTime = Double(seconds)
                    self.countdowner!.setCountdownValue(counter: seconds)
                    
                    self.counter = seconds
                    self.setTime()
                }
            }
        }
    }
    
    func setTime() {
        let countdownerDetails = self.countdowner!.secondsToTime(seconds: counter)
        
        self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", countdownerDetails.timeInMinutes)):\(String(format: "%02d", countdownerDetails.timeInSeconds))")
    }
    
    func handleTimer() {
        if !self.runningTimer {
            startTimer()
            self.runningTimer = true
        } else {
            pauseTimer()
            self.runningTimer = false
        }
    }
    
    func setDefaultCounterValue() {
        self.counter = Int(preferences.counterTime)
    }
    
    func startTimer() {
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        self.countdownTimer?.invalidate()
    }
    
    func resetTimer() {
        let countdownerDetails = self.countdowner!.defaultState(counter: counter)
        
        self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
    }
    
    @objc func update() {
        if counter >= 0 {
            counter -= 1
            
            let countdownerDetails = self.countdowner!.update(counter: counter)
            
            self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
            
        } else {
            self.pauseTimer()
            self.runningTimer = false
            self.setDefaultCounterValue()
        }
    }
    
    func updateWindow(color: CGColor, width: Int, height: Int, x: Int, y: Int, minutes: Int, seconds: Int) {
        self.view.layer?.backgroundColor = color
        appDelegate.setWindow(widthSize: width, heightSize: height, x: x, y: y)
        self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
}
