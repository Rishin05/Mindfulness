//
//  SignUpViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-13.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet var textFieldSignUpEmail: UITextField!
    @IBOutlet var textFieldSignUpPassword: UITextField!
    @IBOutlet var textFieldConfirmPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = textFieldSignUpEmail.text, !email.isEmpty,
              let password = textFieldSignUpPassword.text, !password.isEmpty,
              let confirmPassword = textFieldConfirmPassword.text, !confirmPassword.isEmpty
        else {
            return
        }

        // Validate password and confirm password
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                print("Error signing up: \(error.localizedDescription)")
            } else if let authResult = authResult {
                // Signup successful
                let newUser = User(email: email, uid: authResult.user.uid)
                self.saveUserToDatabase(user: newUser)
                self.navigateToIntro()
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    func navigateToIntro() {
        if let introVC = storyboard?.instantiateViewController(withIdentifier: "IntroViewController") {
            navigationController?.pushViewController(introVC, animated: true)
        }
    }

    func saveUserToDatabase(user: User) {
        _ = Database.database().reference().child("users").child(user.uid)
    }
}
