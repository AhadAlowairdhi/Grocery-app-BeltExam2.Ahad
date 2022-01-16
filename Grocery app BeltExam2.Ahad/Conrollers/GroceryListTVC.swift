//
//  GroceryListTVC.swift
//  Grocery app BeltExam2.Ahad
//
//  Created by administrator on 12/01/2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class GroceryListTVC: UITableViewController {
    
// MARK: Variables & Constants
    
    let userEmail = Auth.auth().currentUser?.email
    let userUid = Auth.auth().currentUser?.uid
    let database = Database.database().reference()/// A Firebase reference points to a Firebase location where the data is stored
     let currentUser = Auth.auth().currentUser!.email // varible holds email of user when login
    
    /// online users
    let usersRef = Database.database().reference(withPath: "online")
    var currentUsers: [String] = []
    var usersRefObservers: [DatabaseHandle] = []
    var user: User?
      var onlineUserCount = UIBarButtonItem()
   
    /// create array of type GroceryDetails struct
     var familyGroceryItems = [GroceryDetails]()
     
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        /// navigation bar
        self.title = "Groceries to Buy"
        onlineUserCount = UIBarButtonItem.init(title: "0", style: .plain, target: self ,action: #selector(onlineUsers))
        self.navigationItem.leftBarButtonItem = onlineUserCount
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addItem))
     
        } //End of viewDidLoad()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        let currentUserRef = self.usersRef.child(userUid!)
        currentUserRef.setValue(userEmail)
        currentUserRef.onDisconnectRemoveValue()
        /// counting how many online users
        let users = usersRef.observe(.value) { snapshot in
          if snapshot.exists() {
            self.onlineUserCount.title = snapshot.childrenCount.description
          } else {
            self.onlineUserCount.title = "0"
          }
        }
        usersRefObservers.append(users)
        
        fetchAllItems()
    } // End of viewWillAppear()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        usersRefObservers.forEach(usersRef.removeObserver(withHandle:))
        usersRefObservers = []

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
      }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return familyGroceryItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryItemCell", for: indexPath)
        
        cell.textLabel!.text = familyGroceryItems[indexPath.row].item // display the item was added by user
        cell.detailTextLabel!.text = familyGroceryItems[indexPath.row].addedByUser // display the user was added item

          return cell
      }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let itemEdit = familyGroceryItems[indexPath.row] // hold item once selected by user
        let alert = UIAlertController(title: "Grocery Item",
                                      message: "Edit an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
            
            guard let textField = alert.textFields?.first,
                  let itemName = textField.text,
                  let user = self.currentUser else { return }
            
           //Edit Item on Database
            DatabaseManager.shared.editItems(pathID: itemEdit.ItemID, Item: itemName, user: user)
            /// update grocery list after editing
           
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
      
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteItem = familyGroceryItems[indexPath.row] // hold item once selected by user
        
                   if editingStyle == .delete {
                       DatabaseManager.shared.deleteItems(path: deleteItem.ItemID)
                       
               }
            
               }

    // MARK: Functions
    
    ///navigate to MonitoringUsersTVC
    @objc func onlineUsers(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MonitoringUsersTVC") as! MonitoringUsersTVC
        self.navigationController?.pushViewController(vc, animated: true)

    }
    ///add grocery item
    @objc func addItem() {
            let alert = UIAlertController(title: "Grocery Item",
                                          message: "Add an Item",
                                          preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default) { _ in
                
                guard let textField = alert.textFields?.first,
                      let itemName = textField.text,
                      let user = self.currentUser else { return }
                
               //Add item to Database
                DatabaseManager.shared.addItems(Item:itemName,user: "\(user)")
             
               
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addTextField()
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }// End of add item function
    
    /// Function to retrieve all data from firebase
    func fetchAllItems()
    {
        //self.familyGroceryItems.removeAll() // to remove the data from array every time to prevent the duplicate
       
        database.child("grocerytasks").observe( .value, with: {snapshot in
       guard let tasksData = snapshot.value as? [String: AnyObject] else{return }
            
            self.familyGroceryItems.removeAll()
            for (_,value) in tasksData
            {
                guard let name = value["item"] as? String,let id = value["ItemID"] as? String,let added = value["Added by"] as? String else { return }
                
                self.familyGroceryItems.append(GroceryDetails(item: name, addedByUser: added, ItemID: id, complete: "false"))
                self.tableView.reloadData()
            }
        })
    
    } // End of fetchAlllItems function

    
} // End Class
