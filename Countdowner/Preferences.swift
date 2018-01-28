//
//  Preferences.swift
//  Countdowner
//
//  Created by Rafael Almeida on 28/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import Cocoa

struct Preferences {
    
    var counterTime: TimeInterval {
        get {
            let savedTime = UserDefaults.standard.double(forKey: "CountdownerCustomTime")
            
            if savedTime > 0 {
                return savedTime
            }
            
            return 1800
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CountdownerCustomTime")
        }
    }
    
}
