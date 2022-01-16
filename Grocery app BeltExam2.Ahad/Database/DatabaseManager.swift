//
//  DatabaseManager.swift
//  Grocery app BeltExam2.Ahad
//
//  Created by administrator on 12/01/2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference() /// A Firebase reference points to a Firebase location where the data is stored
    private let currentUser = Auth.auth().currentUser!.uid /// varible to hold unique id for the user
    
} // End of Class

// MARK: Extensions Section

extension DatabaseManager {
    
// MARK: Function

    // Account Management
    
    ///Function to store item in realtime database
    func addItems (Item: String , user: String)
    {
        let itemId = UUID().uuidString /// This varible is hold randomly string value to store every item with unique value
        var items: GroceryDetails = GroceryDetails() /// create varible of type GroceryDetails()
        items.item = Item
        items.addedByUser = user
        /*
         groceryTasks is a dictionary  its have 3 keys
         Item Id : value is randomly string value
         Item : value is the item its added by user
         Added by user: value is the user who is added item
         */
        let groceryTasks =  ["ItemID":itemId ,
                             "item": items.item ,
                             "Added by": items.addedByUser]
        
        //create child of unique id *itemId* then groceryTasks as dictionary
        database.child("grocerytasks").child(itemId).setValue(groceryTasks)
    }
   
    ///Function to editing item on realtime database
    func editItems (pathID:String,Item: String , user: String )
    {
        var items: GroceryDetails = GroceryDetails()
        items.item = Item
        items.addedByUser = user
        
        /* in groceryTasks the "ItemID" will the id is selected by user in taple view
         and its the way to reach every unique id was created in function *addItems*
         */
        let groceryTasks = ["ItemID": pathID,
                            "item": items.item ,
                            "Added by": items.addedByUser]
        
        //Reach to the path of unique id then set a new value
        database.child("grocerytasks/\(pathID)").setValue(groceryTasks)
        
    }
    ///Function to delete item from realtime database
    func deleteItems (path:String)
    {
        //Reach to the path of unique id then make it a nil to delete
        database.child("grocerytasks/\(path)").setValue(nil)
        
    }

    
} // End of Extension

// MARK: Structs

/// Struct for item details
struct GroceryDetails {
    var item: String = ""
    var addedByUser: String = ""
    var ItemID: String = ""
    var complete: String = "false"
    
    /// check type -> email @ -
    var safeEmail : String{
        var safeEmail = addedByUser.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

/// Struct for user details
struct UserDetails {

    let uid: String
      let email: String

      init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email ?? ""
      }

      init(uid: String, email: String) {
        self.uid = uid
        self.email = email
      }
}
