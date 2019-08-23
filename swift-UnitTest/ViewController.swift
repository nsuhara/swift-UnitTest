//
//  ViewController.swift
//  swift-UnitTest
//
//  Created by nsuhara on 2019/08/23.
//  Copyright © 2019 nsuhara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var subClass: SubClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.subClass = SubClass(viewController: self)
    }
    
    class SubClass {
        private let viewController: ViewController
        
        init(viewController: ViewController) {
            self.viewController = viewController
        }
        
        func multiply(num1: Int, num2: Int) -> Int {
            return num1 * num2
        }
    }

}

