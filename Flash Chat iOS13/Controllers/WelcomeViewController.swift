//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    

    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        titleLabel.text = ""
//        let title = "⚡FlashChat"
//        var timeIndex = 0.0
//        for letter in title {
//            print("-")
//            print(0.1 * timeIndex)
//            print(letter)
//            Timer.scheduledTimer(withTimeInterval: 0.1 * timeIndex, repeats: false) { (TitleTimer) in
//                self.titleLabel.text?.append("\(letter)")
//            }
//            timeIndex += 1
//        }
        
        titleLabel.text = K.appName
        
    
       
    }
    

}
