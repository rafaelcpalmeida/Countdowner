//
//  MinuteSecondPickerView.swift
//  Countdowner iOS
//
//  Created by Rafael Almeida on 12/02/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//
//  Based on MonthYearPickerView-Swift by Ben Dodson
//  Available at https://github.com/bendodson/MonthYearPickerView-Swift
//

import UIKit

class MinuteSecondPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let preferences = Preferences()
    
    var minutes: [Int] = Array(0...60)
    var seconds: [Int] = Array(0...60)
    
    var minute = 0
    
    var second = 0
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.delegate = self
        self.dataSource = self
        
        // show the picker using the stored values
        self.selectRow(Int(preferences.counterTime / 60), inComponent: 0, animated: true)
        self.selectRow(Int(preferences.counterTime.truncatingRemainder(dividingBy: 60)), inComponent: 1, animated: true)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        switch component {
        case 0:
            return NSAttributedString(string: String(format: "%02d", minutes[row]), attributes: [.foregroundColor: UIColor.white])
        case 1:
            return NSAttributedString(string: String(format: "%02d", seconds[row]), attributes: [.foregroundColor: UIColor.white])
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return minutes.count
        case 1:
            return seconds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let minute = minutes[self.selectedRow(inComponent: 0)]
        let second = seconds[self.selectedRow(inComponent: 1)]
        
        if let block = onDateSelected {
            block(minute, second)
        }
        
        self.minute = minute
        self.second = second
    }
    
}

