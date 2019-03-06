//
//  ShoppingListsTableViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/5/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase
class ShoppingListsTableViewController: UITableViewController {

    var ref: DatabaseReference!
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    
 
    var selectedAutoId:String = ""
    var UserList: UserLists!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
        }
        
        //set Database reference
         ref = Database.database().reference()
        
        LoadUserInfo()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if UserList == nil{
            return 0
        }
        return UserList.numLists
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Return false if you do not want the specified item to be editable.
        
        selectedAutoId = UserList.listIDs[indexPath.row]
        
        performSegue(withIdentifier: "toShoppingList", sender: nil)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "toShoppingList"){
            //print(ListNames[selectedCell])
            //This way since im going into a NavigationControllor
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! ListTableViewController
            targetController.autoID = selectedAutoId
            targetController.dir = self.UserList.userID
            targetController.listRef = self.ref.child("User-Lists").child(self.UserList.userID).child("Shopping-Lists").child(selectedAutoId)
            targetController.autoID = selectedAutoId
            targetController.navigationItem.prompt = "My Shopping Lists"
            targetController.type = 1
        
        }
    }
    @IBAction func AddListsClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Create new list",
                                      message: "Enter list name",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            let namefield = alert.textFields![0]
            guard let nameField = namefield.text else{
                return
            }
            if nameField == ""{
                return
            }
            //Save to Database
            guard let autoID = self.ref.child("User-Lists").child(self.UserList.userID).child("Shopping-Lists").childByAutoId().key else{
                return
            }
            
            self.selectedAutoId = autoID
            let newList: List = List.init(name: nameField, autoID: autoID)
            self.ref.child("User-Lists").child(self.UserList.userID).child("Shopping-Lists").child(autoID).setValue(newList.toAnyObject())
            
            self.UserList.listNames.append(nameField)
            self.UserList.listIDs.append(autoID)
            
            self.UserList.numLists += 1
            self.ref.child("User-Lists").child(self.UserList.userID).child("User-S-Info").setValue(self.UserList.toAnyObject())

            self.performSegue(withIdentifier: "toShoppingList", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textName in
            textName.placeholder = "Enter list name"
        }
        

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCelll", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.UserList.listNames[indexPath.row]
        
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
     
     
        return true
    }
    


    @IBAction func unwindFromDone(sender: UIStoryboardSegue) {
        /*if let sourceViewController = sender.source as? GroceryListTableViewController {
        
                //let dataBack = sourceViewController.listName
        }*/
    }
    @IBAction func unwindFromShoppingDelete(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ListTableViewController {
            let listName = sourceViewController.list.name
            let listID = sourceViewController.autoID
            //list num
            self.UserList.numLists -= 1
            //listIDs
            if let IdIndex = self.UserList.listIDs.index(of: listID) {
                self.UserList.listIDs.remove(at: IdIndex)
            }
            //list names
            if let NameIndex = self.UserList.listNames.index(of: listName) {
                self.UserList.listNames.remove(at: NameIndex)
            }
            
            //post house
            self.ref.child("User-Lists").child(UserList.userID).child("User-S-Info").setValue(self.UserList.toAnyObject())
            self.tableView.reloadData()
            
            
        }
    }

    func LoadUserInfo(){
        //Load Items
        
        
        ref.child("User-Lists").child((self.currentUser?.uid)!).child("User-S-Info").observe(.value, with: { (snapshot) -> Void in
            print(snapshot as Any)
            if let actualContent = UserLists(snapshot: snapshot) {
                self.UserList = actualContent
                self.tableView.reloadData()
            }
            
        })
    }

}
