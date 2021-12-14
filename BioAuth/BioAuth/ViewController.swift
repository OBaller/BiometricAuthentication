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
        context.localizedReason = "The app needs your authentication."
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
                        case LAError.Code.appCancel:
                            print("app cancelled")
                        case LAError.Code.userFallback:
                            print("fallback")
                            self.promptForCode()
                        case LAError.Code.authenticationFailed:
                            print("failed")
                        default:
                            print("other error")
                    }
                }
            }
//            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { (t) in
//                self.context.invalidate()
//            }
        }
        else {
            print("Can't evaluate")
            print(errorCanEval?.localizedDescription ?? "no error desc")
            if let err = errorCanEval  {
                let evalErrCode = LAError(_nsError: err as NSError)
                switch evalErrCode.code {
                    case LAError.Code.biometryNotEnrolled:
                        print("not enrolled")
                    default:
                        print("other error")
                }
            }
        }
    }
    
    func promptForCode() {
        let ac = UIAlertController(title: "Enter Code", message: "Enter your user code", preferredStyle: .alert)
        ac.addTextField { (tf) in
            tf.placeholder = "Enter User Code"
            tf.keyboardType = .numberPad
            tf.isSecureTextEntry = true
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (aaction) in
            print(ac.textFields?.first?.text ?? "no value")
        }))
        self.present(ac, animated: true, completion: nil)
    }

}

