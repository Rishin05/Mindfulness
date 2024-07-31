//
//  GetStartedViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-13.
//

import UIKit
import FirebaseAuth
import FirebaseCore


class GetStartedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
                   // User is already logged in, navigate to GetStartedViewController
                   navigateToGetStarted()
               }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("There is a user")
            } else {
                print("There is no active user")
                
            }
        }
    }
    
    func navigateToGetStarted() {
            if let getStartedVC = storyboard?.instantiateViewController(withIdentifier: "IntroViewController") {
                navigationController?.pushViewController(getStartedVC, animated: true)
            }
        }

    

}
