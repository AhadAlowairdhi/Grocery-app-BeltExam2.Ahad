//
//  LoginVC.swift
//  Grocery app BeltExam2.Ahad
//
//  Created by administrator on 12/01/2022.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    
    // MARK: UI Outlet
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    // MARK: Variables
    
    

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // To empty feilds when is logout
        override func viewDidAppear(_ animated: Bool) {
            emailTF.text = ""
            passwordTF.text = ""
        }
    
    // MARK: UI Action
    
    @IBAction func loginBtnActon(_ sender: UIButton) {
        /// check if text fields is empty or not
        guard let email = emailTF.text, let password = passwordTF.text, !email.isEmpty, !password.isEmpty else {
            alertEmpty()
            return
        }
        /// check if password is more than 6 character or not
        guard let pass = passwordTF.text, pass.count >= 6  else {
            alretPassword()
            return
        }
        /// Firebase Login
        Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                print(error?.localizedDescription)
                return
            }
            
            let user = result.user
            print("Logged in user \(user)")
        })
        
        
    } // End of button action
    
    // MARK: Alerts action
    
    // alert check empty
    func alertEmpty() {
        let alert = UIAlertController(title: "Error", message: "Text Fields must be not empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    // alert check password
    func alretPassword(){
        let alert = UIAlertController(title: "Error", message: "Password must be more than 6 character", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}
