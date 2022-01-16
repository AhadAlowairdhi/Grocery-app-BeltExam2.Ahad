//
//  RegisterVC.swift
//  Grocery app BeltExam2.Ahad
//
//  Created by administrator on 13/01/2022.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController {
    
// MARK: Outlet
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var newEmailTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!

// MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        // Do any additional setup after loading the view.
    }

// MARK: IB Action
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        guard let fName = firstNameTF.text, let lName = lastNameTF.text, let eAddress = newEmailTF.text , let nPass = newPasswordTF.text,
                !fName.isEmpty, !lName.isEmpty , !eAddress.isEmpty, !nPass.isEmpty else {
            alertEmpty()
            return
        }
        
        /// Firebase create new user
        Auth.auth().createUser(withEmail: eAddress, password: nPass, completion: { authResult, error in
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
            
            let user = result.user
            print("Created user \(user)")
            
            // if this succeeds, dismiss
                        let GroceryItemsVC =  self.storyboard?.instantiateViewController(withIdentifier: "GroceryListTVC") as! GroceryListTVC
                        self.navigationController?.pushViewController(GroceryItemsVC, animated: true)
        })
    } // End of button action
    
// MARK: Alert function
    
    /// alert check empty
    func alertEmpty(message: String = "Text Fields must be not empty"){
        let alert = UIAlertController(title: "Woops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    } //End of alert action
} // End of class
