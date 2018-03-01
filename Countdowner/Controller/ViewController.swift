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
    var remaininTimeInSeconds = 0
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
        self.countdowner = Countdowner(counter: remaininTimeInSeconds)
        self.setTime()
        self.view.layer?.backgroundColor = .gray

        if let window = self.view.window {
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
        } else {
            addedObserver = true
            self.addObserver(self, forKeyPath: "view.window", options: [.new, .initial], context: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setTimerValue), name: NSNotification.Name(rawValue: "setTimerValue"), object: nil)
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
    }

    func setTime() {
        guard let countdownerDetails = self.countdowner?.secondsToTime(seconds: remaininTimeInSeconds) else { fatalError() }

        self.countDownLabel.stringValue = String(describing: "\(String(format: "%02d", countdownerDetails.timeInMinutes)):\(String(format: "%02d", countdownerDetails.timeInSeconds))")
    }

    func handleTimer() {
        if !self.runningTimer {
            if self.remaininTimeInSeconds == 0 {
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
        self.remaininTimeInSeconds = Int(preferences.counterTime)
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
        DispatchQueue.main.async {
            self.countdownerService.send(action: .pause)

            self.countdownTimer?.invalidate()
            
            if self.remaininTimeInSeconds > 0 {
                self.view.layer?.backgroundColor = .gray
            }
        }
    }

    func resetTimer() {
        self.countdownerService.send(action: .reset)

        self.handleTimer()

        self.setDefaultCounterValue()

        let countdownerDetails = self.countdowner!.defaultState(counter: remaininTimeInSeconds)

        self.updateWindow(color: countdownerDetails.color, width: countdownerDetails.window.width, height: countdownerDetails.window.height, x: countdownerDetails.window.x, y: countdownerDetails.window.y, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
    }

    @objc func update() {
        if remaininTimeInSeconds > 0 {
            remaininTimeInSeconds -= 1

            guard let countdownerDetails = self.countdowner?.update(counter: remaininTimeInSeconds) else { fatalError() }

            
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
    
    @objc func setCoutdownerTime(seconds: Int) {
        self.preferences.counterTime = Double(seconds)
        self.countdowner?.setCountdownValue(counter: seconds)
        self.setTime()
    }
    
    @objc func setTimerValue() {
        self.remaininTimeInSeconds = Int(self.preferences.counterTime)
        self.countdowner?.setCountdownValue(counter: remaininTimeInSeconds)
        self.setTime()
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
