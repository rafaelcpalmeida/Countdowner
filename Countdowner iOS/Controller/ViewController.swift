//
//  ViewController.swift
//  Countdowner iOS
//
//  Created by Rafael Almeida on 29/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: UILabel!
    
    let countdownerService = CountdownerServiceManager()
    
    var counter: Int = 0
    var countdownTimer: Timer? = nil
    var countdowner: Countdowner? = nil
    var runningTimer: Bool = false
    var preferences = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownerService.delegate = self
        
        self.setDefaultCounterValue()
        self.countdowner = Countdowner(counter: counter)
        self.setTime()
        
        self.view.layer.backgroundColor = CGColor.green
            
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapRecognizer(_ sender: Any) {
        self.handleTimer()
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "Please insert the value, in seconds, of the timer:", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "30 minutes equals to 1800 seconds"
            textField.keyboardType = .numberPad
            textField.clearButtonMode = .whileEditing
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            if let seconds = Int((alert.textFields?.first?.text)!) {
                if seconds > 0 && seconds < 3600 {
                    self.preferences.counterTime = Double(seconds)
                    self.countdowner!.setCountdownValue(counter: seconds)
                    
                    self.counter = seconds
                    self.setTime()
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "Seconds must be higher than 0 and lower than 3600", preferredStyle: .alert)
                    
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    
                    self.present(errorAlert, animated: true)
                }
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    func setTime() {
        let countdownerDetails = self.countdowner!.secondsToTime(seconds: counter)
        
        self.countDownLabel.text = String(describing: "\(String(format: "%02d", countdownerDetails.timeInMinutes)):\(String(format: "%02d", countdownerDetails.timeInSeconds))")
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
        self.countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        self.countdownTimer?.invalidate()
    }
    
    func resetTimer() {
        self.setDefaultCounterValue()
        
        let countdownerDetails = self.countdowner!.defaultState(counter: counter)
        
        self.updateWindow(color: countdownerDetails.color, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
    }
    
    @objc func update() {
        if counter > 0 {
            counter -= 1
            
            let countdownerDetails = self.countdowner!.update(counter: counter)
            
            self.updateWindow(color: countdownerDetails.color, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
            
            print(counter)
        } else {
            self.pauseTimer()
            self.runningTimer = false
        }
    }
    
    func updateWindow(color: CGColor, minutes: Int, seconds: Int) {
        self.view.layer.backgroundColor = color
        self.countDownLabel.text = String(describing: "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))")
    }
    
}

extension ViewController : CountdownerServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: CountdownerServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            //self.connectionsLabel.text = "Connections: \(connectedDevices)"
            print(connectedDevices)
        }
    }
    
    //func actionReceived(manager : CountdownerServiceManager, action: ACTION, counter: Int) {
    func actionReceived(manager : CountdownerServiceManager, action: ACTION) {
        OperationQueue.main.addOperation {
            print("Received something")
            
            switch action {
            case .start:
                //self.counter = counter
                if !self.runningTimer {
                    self.startTimer()
                }
            case .pause:
                if self.runningTimer {
                    self.pauseTimer()
                }
            case .restart:
                self.resetTimer()
            }
        }
    }
    
}

