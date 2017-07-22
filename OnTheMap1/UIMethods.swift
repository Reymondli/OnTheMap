//
//  UIMethods.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-21.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit

// This file defines some common UI methods thats needed for the App, such as Alert, Keyboard Methods, etc.
extension UIViewController {
    // MARK: - Alert
    func displayAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: UITextFieldDelegate {
    // ----------Keyboard Methods---------- //
    // MARK: Keyboard Adjustments - Show
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        self.view.frame.origin.y = getKeyboardHeight(notification) * (-1)
    }
    
    // MARK: Keyboard Adjustments - Hide
    func keyboardWillHide(_ notification:Notification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Dismiss the keyboard after pressing "Enter"
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
