//
//  Preferences.swift
//  Countdowner
//
//  Created by Rafael Almeida on 28/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

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
