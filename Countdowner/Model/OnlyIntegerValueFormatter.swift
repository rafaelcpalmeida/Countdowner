//
//  OnlyIntegerValueFormatter.swift
//  Countdowner
//
//  Created by Rafael Almeida on 29/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import Cocoa

class OnlyIntegerValueFormatter: NumberFormatter {

    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        // Ability to reset your field (otherwise you can't delete the content)
        // You can check if the field is empty later
        if partialString.isEmpty {
            return true
        }
        
        // Limit the number of seconds to 3600 (1 hour) as the program is only prepared to countdown minutes
        if let number = Int(partialString), number > 3600 {
            return false
        }
        
        // Actual check
        return Int(partialString) != nil
    }
    
    // Props to Xavier Daleau
    // https://stackoverflow.com/a/39935157/3431018
}
