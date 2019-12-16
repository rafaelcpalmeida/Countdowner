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

    var counter = 0
    var countdownTimer: Timer?
    var countdowner: Countdowner?
    var runningTimer = false
    var preferences = Preferences()

    override func viewDidLoad() {
        super.viewDidLoad()

        countdownerService.delegate = self

        self.setDefaultCounterValue()
        self.countdowner = Countdowner(counter: counter)
        self.setTime()

        self.view.layer.backgroundColor = .gray

        UIApplication.shared.isIdleTimerDisabled = true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapRecognizer(_ sender: Any) {
        self.handleTimer()
    }

    @IBAction func doubleTouchTapRecognizer(_ sender: Any) {
        self.resetTimer()
    }

    @IBAction func settingsButton(_ sender: Any) {
        let views = view.subviews.filter { $0 is MinuteSecondPickerView }

        if views.count > 0 {
            views.forEach { $0.removeFromSuperview() }
        } else {
            let minutesSecondsPicker = MinuteSecondPickerView()

            minutesSecondsPicker.frame.size.width = self.view.frame.width / 3
            minutesSecondsPicker.frame.size.height = self.view.frame.height / 3

            minutesSecondsPicker.center = CGPoint(x: self.view.frame.width / 2, y: (self.view.frame.height - minutesSecondsPicker.frame.height) + (minutesSecondsPicker.frame.size.height / 2))

            minutesSecondsPicker.onDateSelected = { minutes, seconds in
                let seconds = (minutes * 60) + seconds

                self.preferences.counterTime = Double(seconds)
                self.countdowner?.setCountdownValue(counter: seconds)

                self.counter = seconds
                self.setTime()
            }

            self.view.addSubview(minutesSecondsPicker)
        }
    }

    func setTime() {
        guard let countdownerDetails = self.countdowner?.secondsToTime(seconds: counter) else { fatalError() }

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
        self.countdownTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        
        self.view.layer.backgroundColor = .green
    }

    func pauseTimer() {
        self.countdownTimer?.invalidate()
        
        self.view.layer.backgroundColor = .gray
    }

    func resetTimer() {
        self.setDefaultCounterValue()

        guard let countdownerDetails = self.countdowner?.defaultState(counter: counter) else { fatalError() }

        self.updateWindow(color: countdownerDetails.color, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
    }

    @objc func update() {
        if counter > 0 {
            counter -= 1

            guard let countdownerDetails = self.countdowner?.update(counter: counter) else { fatalError() }

            self.updateWindow(color: countdownerDetails.color, minutes: countdownerDetails.minutes, seconds: countdownerDetails.seconds)
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
        //
    }

    func actionReceived(manager: CountdownerServiceManager, action: Action) {
        OperationQueue.main.addOperation {
            switch action {
            case .start:
                if !self.runningTimer {
                    if self.counter == 0 {
                        self.resetTimer()
                    }
                    self.startTimer()
                    self.runningTimer = true
                }
            case .pause:
                if self.runningTimer {
                    self.pauseTimer()
                    self.runningTimer = false
                }
            case .reset:
                self.resetTimer()
            }
        }
    }

}
