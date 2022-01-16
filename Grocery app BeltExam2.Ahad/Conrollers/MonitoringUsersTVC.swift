//
//  MonitoringUsersTVC.swift
//  Grocery app BeltExam2.Ahad
//
//  Created by administrator on 15/01/2022.
//

import UIKit
import Firebase

class MonitoringUsersTVC: UITableViewController {
    
    
    // MARK: Var & Const
    var currentUsers: [String] = []
    let usersRef = Database.database().reference(withPath: "online") //add a local reference to Firebase’s online users
    var usersRefObservers: [DatabaseHandle] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // nav bar > sign out account
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(didTapLogout))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        /// This code renders items as users come online.
        let childAdded = usersRef
            .observe(.childAdded) { [weak self] snap in
                guard
                    let email = snap.value as? String,
                    let self = self
                else { return }
                self.currentUsers.append(email)
                let row = self.currentUsers.count - 1
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .top)
            }
        usersRefObservers.append(childAdded)
        
        /// Since users can also go offline, the table needs to react to it by removing them
        let childRemoved = usersRef
            .observe(.childRemoved) {[weak self] snap in
                guard
                    let emailToFind = snap.value as? String,
                    let self = self
                else { return }
                
                for (index, email) in self.currentUsers.enumerated()
                where email == emailToFind {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.currentUsers.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        usersRefObservers.append(childRemoved)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        /// removes relevant observers from usersRef.
        usersRefObservers.forEach(usersRef.removeObserver(withHandle:))
        usersRefObservers = []
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    // MARK: Functions
    
    /// Firebase sign out
    @objc func didTapLogout(){
        guard let user = Auth.auth().currentUser else { return }
        
        let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
        onlineRef.removeValue { error, _ in
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
        }
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let error {
            print("Auth sign out failed: \(error)")
        }
        
    } // End of didTapLogout function
    
} //End of class




