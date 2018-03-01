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
    @IBOutlet weak var connectedPeers: NSTextField!

    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let countdownerService = CountdownerServiceManager()

    var addedObserver = false
    var counter = 0
    var countdownTimer: Timer?
    var countdowner: Countdowner?
    var runningTimer = false
    var preferences = Preferences()
    
    lazy var sheetViewController: NSViewController = {
        return self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "SheetViewController"))
            as! NSViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.countdownerService.delegate = self

        self.setDefaultCounterValue()
        self.countdowner = Countdowner(counter: counter)
        self.setTime()
        self.view.layer?.backgroundColor = .gray

        if let window = self.view.window {
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
        } else {
            addedObserver = true
            self.addObserver(self, forKeyPath: "view.window", options: [.new, .initial], context: nil)
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let window = self.view.window {
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.overlayWindow)))
        }
    }

    deinit {
        if addedObserver {
            self.removeObserver(self, forKeyPath: "view.window")
        }
    }

    override func mouseDown(with theEvent: NSEvent) {
        self.handleTimer()
    }

    override func rightMouseDown(with theEvent: NSEvent) {
        self.resetTimer()
    }

    @IBAction func settingsButton(_ sender: NSButton) {
        self.presentViewControllerAsSheet(sheetViewController)
        /*let alert = NSAlert()
        let secondsField = NSTextField(frame: NSRect(x: 0, y: 0, width: 300, height: 24))

        secondsField.placeholderString = NSLocalizedString("30 minutes equals to 1800 seconds", comment: "")
        secondsField.formatter = OnlyIntegerValueFormatter()

        alert.messageText = NSLocalizedString("Please insert the value, in seconds, of the timer:", comment: "")
        alert.alertStyle = .informational
        alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        alert.accessoryView = secondsField

        if alert.runModal() == .alertFirstButtonReturn,
            let seconds = Int(secondsField.stringValue),
            seconds > 0 {
            self.preferences.counterTime = Double(seconds)
            self.countdowner?.setCountdownValue(counter: seconds)

            self.counter = seconds
        }*/
    }

    func setTime() {
        guard let countdownerDetails = self.countdowner?.secondsToTime(seconds: counter) else { fatalError() }

        self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", countdownerDetails.timeInMinutes)):\(String(format: "%02d", countdownerDetails.timeInSeconds))")
    }

    func handleTimer() {
        if !self.runningTimer {
            if self.counter == 0 {
                self.resetTimer()
            }
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
        self.countdownerService.send(action: .start)
        
        DispatchQueue.global(qos: .background).async(execute: {() -> Void in
            self.countdownTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            
            RunLoop.current.add(self.countdownTimer!, forMode: .defaultRunLoopMode)
            RunLoop.current.run()
        })
        
        self.view.layer?.backgroundColor = .green
    }

    func pauseTimer() {
        self.countdownerService.send(action: .pause)

        self.countdownTimer?.invalidate()
        
        self.view.layer?.backgroundColor = .gray
    }

    func resetTimer() {
        self.countdownerService.send(action: .reset)

        self.handleTimer()

        self.setDefaultCounterValue()

        let countdownerDetails = self.countdowner!.defaultState(counter: counter)

        self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
    }

    @objc func update() {
        if counter > 0 {
            counter -= 1

            guard let countdownerDetails = self.countdowner?.update(counter: counter) else { fatalError() }

            
            self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
        } else {
            self.pauseTimer()
            self.runningTimer = false
        }
    }

    func updateWindow(color: CGColor, width: Int, height: Int, x: Int, y: Int, minutes: Int, seconds: Int) {
        DispatchQueue.main.async {
            self.view.layer?.backgroundColor = color
            self.appDelegate.setWindow(width: width, height: height, x: x, y: y)
            self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
        }
    }

}

extension ViewController : CountdownerServiceManagerDelegate {

    func connectedDevicesChanged(manager: CountdownerServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectedPeers.stringValue = "Connected devices: \(connectedDevices.count)"
        }
    }

    func actionReceived(manager : CountdownerServiceManager, action: Action) {
        OperationQueue.main.addOperation {
        }
    }

}
