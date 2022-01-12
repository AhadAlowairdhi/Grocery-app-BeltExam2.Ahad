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
    
    // MARK: UI Action
    
    @IBAction func loginBtnActon(_ sender: UIButton) {
        // check if text fields is empty or not
        guard let email = emailTF.text, let password = passwordTF.text, !email.isEmpty, !password.isEmpty else {
            alertEmpty()
            return
        }
        // check if password is more than 6 character or not
        guard let pass = passwordTF.text, pass.count >= 6  else {
            alretPassword()
            return
        }
        
        // Fierbase Auth Sign up
        
        
    }
    
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
        // check if text fields is empty or not
        guard let newEmail = emailTF.text, let newPassword = passwordTF.text,
              !newEmail.isEmpty, !newPassword.isEmpty else{
                  alertEmpty()
                  return
              }
                
                
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
