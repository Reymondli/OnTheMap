//
//  LoginViewController.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-13.
//  Copyright © 2017 ziming li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: - Login Button
    @IBAction func loginPressed(_ sender: UIButton? = nil) {
        guard emailTextField.text!.isEmpty == false && passwordTextField.text!.isEmpty == false else {
            displayAlert(message: "Email or Password cannot be empty", title: "Login Failed")
            return
        }
        // Might Add an Spinning Icon Indicating "Processing"
        
        // MARK: - Authenticate with Udacity Credential
        UdacityClient.sharedInstance().authenticationByUdacity(username: emailTextField.text!, password: passwordTextField.text!){ (error: String?) in
            // Execute on the Main Thread when Dealing with UIKit
            DispatchQueue.main.async(execute: {
                guard error == nil else {
                    self.displayAlert(message: error!, title: "Login Failed")
                    return
                }
            let nextController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationController")
            self.present(nextController, animated: true, completion: nil)
            })
        }
    }

    
    // MARK: - Sign-Up Button
    @IBAction func signupPressed(_ sender: Any) {
        if let url = URL(string: UdacityClient.Constants.udacitySignup) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Alert
    func displayAlert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
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

}

extension LoginViewController: UITextFieldDelegate {
    // Dismiss the keyboard after pressing "Enter"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

