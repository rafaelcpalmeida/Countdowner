//
//  Countdowner.swift
//  Countdowner
//
//  Created by Rafael Almeida on 28/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

class Countdowner {
    var counter: Int = 0
    var alert: Double = 0
    var danger: Double = 0
    var color: CGColor?
    var window: WindowSettings?
    
    init(counter: Int) {
        self.setCountdownValue(counter: counter)
    }
    
    func update(counter: Int) -> (window: WindowSettings, color: CGColor, minutes: Int, seconds: Int) {
        let minutes = counter / 60
        let seconds = counter % 60
        
        switch Double(counter) {
        case self.danger ... self.alert:
            color = .yellow
            window = WindowSettings(width: 300, height: 200, x: 50, y: 50)
        case 0 ... self.danger:
            color = .red
            window = WindowSettings(width: 400, height: 300, x: 75, y: 75)
        default:
            return self.defaultState(counter: counter)
        }
        
        return (window: window!, color: color!, minutes: minutes, seconds: seconds)
    }
    
    func secondsToTime(seconds: Int) -> (timeInMinutes: Int, timeInSeconds: Int) {
        return (timeInMinutes: seconds / 60, timeInSeconds: seconds % 60)
    }
    
    func defaultState(counter: Int) -> (window: WindowSettings, color: CGColor, minutes: Int, seconds: Int) {
        let minutes = counter / 60
        let seconds = counter % 60
        
        color = .green
        window = WindowSettings(width: 200, height: 100, x: 25, y: 25)
        
        return (window: window!, color: color!, minutes: minutes, seconds: seconds)
    }
    
    func setCountdownValue(counter: Int) {
        self.counter = counter
        self.alert = Double(counter) * 0.33
        self.danger = Double(counter) * 0.17
    }
}
