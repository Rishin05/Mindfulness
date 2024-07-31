//
//  MainTabViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-17.
//

import UIKit
import Firebase
import FirebaseAuth

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutButtonTapped))
                navigationItem.rightBarButtonItem = signOutButton
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func signOutButtonTapped() {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                self.navigateToGetStarted()
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }
        alertController.addAction(signOutAction)
        
        present(alertController, animated: true, completion: nil)
    }


        func navigateToGetStarted() {
            if let getStartedVC = storyboard?.instantiateViewController(withIdentifier: "GetStartedViewController") {
                navigationController?.setViewControllers([getStartedVC], animated: true)
            }
        }

}
