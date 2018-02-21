//
//  CGColor.swift
//  Countdowner iOS
//
//  Created by Rafael Almeida on 29/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit

    typealias Color = UIColor
#elseif os(OSX)
    import Cocoa

    typealias Color = NSColor
#endif

extension CGColor {
    static var green = Color(red:0.30, green:0.69, blue:0.31, alpha:1.0).cgColor
    static var yellow = Color(red:1.00, green:0.92, blue:0.23, alpha:1.0).cgColor
    static var red = Color(red:0.96, green:0.26, blue:0.21, alpha:1.0).cgColor
}
