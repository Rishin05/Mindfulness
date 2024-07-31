//
//  IntroViewController.swift
//  Mindfulness
//
//  Created by Rishin Patel on 2024-04-17.
//

import UIKit

class IntroViewController: UIViewController {

    
    var firstName: String?
    var lastName: String?
    var reminderDays: [String]?
    var reminderTime: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func continueButtonPressed(_ sender: UIButton) {
           navigateToMainTabBarScreen()
       }
       
       func navigateToMainTabBarScreen() {
           // Assuming MainTabBarScreen is the identifier for your Main Tab Bar Screen
           if let mainTabBarVC = storyboard?.instantiateViewController(withIdentifier: "MainTabBarScreen") {
               navigationController?.pushViewController(mainTabBarVC, animated: true)
           }
       }
}
