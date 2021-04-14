//
//  TextFieldExtension.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 14.04.21.
//

import Foundation
import UIKit

extension UIViewController: UITextFieldDelegate {
    
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        }
        
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
}
