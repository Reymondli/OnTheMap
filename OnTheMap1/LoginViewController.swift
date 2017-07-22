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
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        UdacityClient.sharedInstance.authenticationByUdacity(username: emailTextField.text!, password: passwordTextField.text!){ (error: String?) in
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
}


