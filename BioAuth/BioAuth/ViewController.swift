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
        context.touchIDAuthenticationAllowableReuseDuration = LATouchIDAuthenticationMaximumAllowableReuseDuration
        evaluatePolicy()
    }
    
    func evaluatePolicy() {
        var errorCanEval: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorCanEval) {
            switch context.biometryType {
                case .faceID:
                    print("face id")
                case .none:
                    print("none")
                case .touchID:
                    print("touch id")
                @unknown default:
                    print("unknown")
            }
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Fallback title - override reasoon") { (success, error) in
                print(success)
                if let err = error {
                    let evalErrCode = LAError(_nsError: err as NSError)
                    switch evalErrCode.code {
                        case LAError.Code.userCancel:
                            print("user cancelled")
                        case LAError.Code.userFallback:
                            print("fallback")
                        case LAError.Code.authenticationFailed:
                            print("failed")
                        default:
                            print("other error")
                    }
                }
                    
            }
        }
        else {
            print("Can't evaluate")
            print(errorCanEval?.localizedDescription ?? "no error desc")
        }
    }

}

