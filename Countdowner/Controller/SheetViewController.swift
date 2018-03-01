//
//  SheetViewController.swift
//  Countdowner
//
//  Created by Rafael Almeida on 01/03/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import Cocoa

class SheetViewController: NSViewController {
    
    @IBOutlet weak var timeStepper: NSStepper!
    @IBOutlet weak var timeDisplay: NSTextField!
    
    var preferences = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timeStepper.cell?.integerValue = Int(preferences.counterTime)
        timeDisplay.stringValue = convertTime(seconds: (timeStepper.cell?.integerValue)!)
    }
    
    
    @IBAction func timeChanged(_ sender: NSStepper) {
        timeDisplay.stringValue = convertTime(seconds: (timeStepper.cell?.integerValue)!)
    }
    
    @IBAction func setButton(_ sender: NSButton) {
        self.preferences.counterTime = Double((timeStepper.cell?.integerValue)!)
        self.dismiss(true)
    }
    
    @IBAction func cancelButton(_ sender: NSButton) {
        self.dismiss(true)
    }
    
    func convertTime(seconds: Int) -> String {
        return String(describing: "\(String(format: "%02d", seconds / 60)):\(String(format: "%02d", seconds % 60))")
    }
}
