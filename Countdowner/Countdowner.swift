//
//  Countdowner.swift
//  Countdowner
//
//  Created by Rafael Almeida on 28/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import Foundation
import Cocoa

class Countdowner {
    var counter: Int = 0
    var alert: Double = 0
    var danger: Double = 0
    
    init(counter: Int) {
        self.counter = counter
        self.alert = Double(counter) * 0.33
        self.danger = Double(counter) * 0.17
    }
    
    func update(counter: Int) -> (window: WindowSettings, color: CGColor, minutes: Int, seconds: Int) {
        let minutes = counter / 60
        let seconds = counter % 60
        var color: CGColor? = nil
        var window: WindowSettings? = nil
        
        switch Double(counter) {
        case danger ... alert:
            color = NSColor.yellow
            window = WindowSettings(width: 300, height: 200, x: 50, y: 50)
        case 0 ... danger:
            color = NSColor.red
            window = WindowSettings(width: 400, height: 300, x: 75, y: 75)
        default:
            color = NSColor.green
            window = WindowSettings(width: 200, height: 100, x: 25, y: 25)
        }
        
        return (window: window!, color: color!, minutes: minutes, seconds: seconds)
    }
}

struct WindowSettings {
    var width: Int = 0
    var height: Int = 0
    var x: Int = 0
    var y: Int = 0
    
    init(width: Int, height: Int, x: Int, y: Int) {
        self.width = width
        self.height = height
        self.x = x
        self.y = y
    }
}

extension NSColor {
    static var green = NSColor(red:0.30, green:0.69, blue:0.31, alpha:1.0).cgColor
    static var yellow = NSColor(red:1.00, green:0.92, blue:0.23, alpha:1.0).cgColor
    static var red = NSColor(red:0.96, green:0.26, blue:0.21, alpha:1.0).cgColor
}
