//
//  ViewController.swift
//  BioAuth
//
//  Created by naseem on 14/12/2021.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    var context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        context.localizedCancelTitle = "End Session"
        context.localizedFallbackTitle = " Use passcode (2)"
        context.localizedReason = " The app needs your authentication."
        
    }


}

