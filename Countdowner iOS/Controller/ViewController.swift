//
//  ViewController.swift
//  Countdowner iOS
//
//  Created by Rafael Almeida on 29/01/18.
//  Copyright © 2018 Rafael Almeida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var countdowner: Countdowner? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.countdowner = Countdowner(counter: 60)
        
        self.view.layer.backgroundColor = CGColor.green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

