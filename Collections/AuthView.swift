//
//  AuthView.swift
//  Collections
//
//  Created by Gibson Smiley on 5/5/16.
//  Copyright © 2016 Gibson Smiley. All rights reserved.
//

import UIKit

class AuthView: UITableViewController, UITextFieldDelegate {

    // MARK: - Outlets
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUserCheck()
        
        // Text Field Delegation //
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        urlTextField.delegate = self
        bioTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Text Field Actions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            if loginButton.titleLabel?.text == "Cancel" {
                enterButtonTapped(self)
            } else {
                self.usernameTextField.becomeFirstResponder()
            }
        } else if textField == self.usernameTextField {
            self.urlTextField.becomeFirstResponder()
        } else if textField == self.urlTextField {
            self.bioTextField.becomeFirstResponder()
        } else if textField == self.bioTextField {
            enterButtonTapped(self)
        }
        return true
    }
    
    func resignAllFields() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        bioTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
    }
    
    // MARK: - Button Actions
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if loginButton.titleLabel?.text == "Cancel" {
            topLabel.text = "Let's get you set \nup with an account."
            passwordTextField.placeholder = "Choose a strong password. *"
            loginButton.setTitle("I've already got one", forState: .Normal)
            usernameTextField.hidden = false
            urlTextField.hidden = false
            bioTextField.hidden = false
            resignAllFields()
        } else {
            topLabel.text = "Welcome back! Enter \nyour info and let's go."
            passwordTextField.placeholder = "Enter your password. *"
            loginButton.setTitle("Cancel", forState: .Normal)
            usernameTextField.hidden = true
            urlTextField.hidden = true
            bioTextField.hidden = true
            resignAllFields()
        }
    }
    
    @IBAction func enterButtonTapped(sender: AnyObject) {
        resignAllFields()
        if loginButton.titleLabel?.text == "Cancel" {
            if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true {
                topLabel.text = "Fill all required fields to enter."
            } else {
                // Log into account //
                UserController.authenticateUser(emailTextField.text!, password: passwordTextField.text!, completion: { (success, user) in
                    if success, let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.topLabel.text = "Uh oh! Something went wrong \ntrying to log in. Please try again."
                    }
                })
            }
        } else {
            if emailTextField.text?.isEmpty == true || passwordTextField.text?.isEmpty == true || usernameTextField.text?.isEmpty == true {
                topLabel.text = "Fill all required fields to enter."
            } else {
                // Create new account //
                UserController.createUser(emailTextField.text!, password: passwordTextField.text!, username: usernameTextField.text!, bio: bioTextField?.text, url: urlTextField?.text, completion: { (success, user) in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
    
    // MARK: - Navigation
    
    func currentUserCheck() {
        if UserController.sharedController.currentUser != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}
