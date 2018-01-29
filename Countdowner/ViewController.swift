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
    var preferences = Preferences()
    
    var addedObserver: Bool = false
    var counter: Int = 0
    var countdownTimer: Timer? = nil
    var countdowner: Countdowner? = nil
    var runningTimer: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultCounterValue()
        self.countdowner = Countdowner(counter: counter)
        self.setTime()
        self.view.layer?.backgroundColor = NSColor.green
        
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
        showInputDialog()
    }
    
    func setTime() {
        let countdownerDetails = self.countdowner!.secondsToTime(seconds: counter)
        
        self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", countdownerDetails.timeInMinutes)):\(String(format: "%02d", countdownerDetails.timeInSeconds))")
    }
    
    @objc func update() {
        if counter >= 0 {
            let countdownerDetails = self.countdowner!.update(counter: counter)
            
            self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
            
            counter -= 1
        } else {
            self.pauseTimer()
            self.runningTimer = false
            self.setDefaultCounterValue()
        }
    }
    
    func showInputDialog() {
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
                    preferences.counterTime = Double(seconds)
                    
                    self.counter = seconds
                    self.setTime()
                }
            }
        }
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
    
    func startTimer() {
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        self.countdownTimer?.invalidate()
    }
    
    func resetTimer() {
        let countdownerDetails = self.countdowner!.defaultState(counter: counter)
        
        self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
    }
    
    func setDefaultCounterValue() {
        self.counter = Int(preferences.counterTime)
    }
    
    func updateWindow(color: CGColor, width: Int, height: Int, x: Int, y: Int, minutes: Int, seconds: Int) {
        self.view.layer?.backgroundColor = color
        appDelegate.setWindow(widthSize: width, heightSize: height, x: x, y: y)
        self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
}

class OnlyIntegerValueFormatter: NumberFormatter {
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        // Ability to reset your field (otherwise you can't delete the content)
        // You can check if the field is empty later
        if partialString.isEmpty {
            return true
        }
        
        // Limit the number of seconds to 3600 (1 hour) as the program is only prepared to countdown minutes
        if let number = Int(partialString) {
            if number > 3600 {
                return false
            }
        }
        
        // Actual check
        return Int(partialString) != nil
    }
    
    // Props to Xavier Daleau
    // https://stackoverflow.com/a/39935157/3431018
}
