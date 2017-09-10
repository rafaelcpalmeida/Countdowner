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
    
    var addedObserver: Bool = false
    var counter: Int = 1800
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = self.view.window {
            window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.floatingWindow))
        } else {
            addedObserver = true
            self.addObserver(self, forKeyPath: "view.window", options: [.new, .initial], context: nil)
        }
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let window = self.view.window {
            window.level = Int(CGWindowLevelForKey(CGWindowLevelKey.overlayWindow))
        }
    }
    
    deinit {
        if addedObserver {
            self.removeObserver(self, forKeyPath: "view.window")
        }
    }
    
    func update() {
        if(counter >= 0) {
            let minutes = String(format: "%02d", counter / 60)
            let seconds = String(format: "%02d", counter % 60)
            
            self.countDownLabel.stringValue = String(describing: "\(minutes):\(seconds)")
            
            counter -= 1
        }
    }
}
