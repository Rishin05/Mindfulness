//
//  LoginViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-13.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet var textFieldLoginEmail: UITextField!
    @IBOutlet var textFieldLoginPassword: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("There is a user")
            } else {
                print("There is no active user")
                
            }
        }

    }
   
    

    @IBAction func loginDidTouch(_ sender: AnyObject) {
        ///Check email and password field are not empty
        guard let email = textFieldLoginEmail.text, !email.isEmpty,
              let password = textFieldLoginPassword.text, !password.isEmpty
        else {
            // Show an alert if email or password is empty
            let alert = UIAlertController(title: "Sign in Failed", message: "Please enter both email and password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                // Sign-in failed
                let alert = UIAlertController(title: "Sign in Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else if let _ = user {
                self.navigateToIntro()
            }
        }
    }


    func navigateToIntro() {
        if let user = Auth.auth().currentUser {
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                guard let self = self else { return }
                
                guard let userData = snapshot.value as? [String: Any] else {
                    print("User data not found in database")
                    return
                }
                
                // Extract first name and last name from user data
                guard let firstName = userData["firstName"] as? String,
                      let lastName = userData["lastName"] as? String else {
                    print("First name or last name not found in user data")
                    return
                }
                
                // Check if the user has a reminder saved
                if let reminderData = userData["reminder"] as? [String: Any],
                   let days = reminderData["days"] as? [String],
                   let time = reminderData["time"] as? String {
                    // Pass first name, last name, and reminder data to IntroViewController
                    if let introVC = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
                        introVC.firstName = firstName
                        introVC.lastName = lastName
                        introVC.reminderDays = days
                        introVC.reminderTime = time
                        self.navigationController?.pushViewController(introVC, animated: true)
                    }
                } else {
                    // If the user does not have a reminder saved, navigate to IntroViewController without reminder data
                    if let introVC = self.storyboard?.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController {
                        introVC.firstName = firstName
                        introVC.lastName = lastName
                        self.navigationController?.pushViewController(introVC, animated: true)
                    }
                }
                
            }) { (error) in
                print("Error fetching user data: \(error.localizedDescription)")
            }
        } else {
            print("No active user")
        }
    }

        
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Reset Password", message: "Enter your email to reset your password", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Email"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let resetPasswordAction = UIAlertAction(title: "Reset Password", style: .default) { [weak self] _ in
            guard let email = alertController.textFields?.first?.text, !email.isEmpty else {
                // Handle empty email
                return
            }
            
            self?.resetPassword(email: email)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(resetPasswordAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                // Handle error
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                // Password reset email sent successfully
                let alert = UIAlertController(title: "Password Reset", message: "Password reset email has been sent to \(email)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }


}
