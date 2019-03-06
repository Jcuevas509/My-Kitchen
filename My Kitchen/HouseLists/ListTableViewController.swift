//
//  ListTableViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/27/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase
class ListTableViewController: UITableViewController {

    var autoID: String = String()
    var list: List!
    var listRef: DatabaseReference!
    var type: Int = 0
    var ref: DatabaseReference!
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    var curUserEntry : UserEntry!
    var dir: String = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
        }
        //set Database reference
        ref = Database.database().reference()
        
        LoadList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if list == nil{
            return 0
        }
        return list.numItems
    }

    func LoadList(){
        //Load Items
        
        listRef.observe(.value, with: { (snapshot) -> Void in
            print(snapshot as Any)
            if let actualContent = List(snapshot: snapshot) {
                self.list = actualContent
                self.navigationItem.title = self.list.name
                self.tableView.reloadData()
            }
            
        })
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel!.text = self.list.Items[indexPath.row]
        return cell
    }
 
    @IBAction func addPressed(_ sender: Any) {
        let alert = UIAlertController(title: "List Item",
                                      message: "Enter item",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let namefield = alert.textFields![0]
            guard let nameField = namefield.text else{
                return
            }
            if nameField == ""{
                return
            }
           
            
            
            self.list.numItems += 1
            self.list.Items.append(nameField)
            
            self.postList()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textName in
            textName.placeholder = "Enter Item"
        }
        
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    func postList(){
        listRef.setValue(self.list.toAnyObject())
    }
    @IBAction func DeleteListTapped(_ sender: Any) {
        // Return false if you do not want the specified item to be editable.
        let alert = UIAlertController(title: "This action cannot be undone.",
                                      message: "Are you sure you want to delete this list?",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            //delete list
            self.listRef.setValue(nil)
            //unwind then delete list
            switch self.type {
            case 0:
                self.performSegue(withIdentifier: "unwindFromHouseDelete", sender: self)
            case 1:
                self.performSegue(withIdentifier: "unwindShoppingDelete", sender: self)
            case 2:
                self.performSegue(withIdentifier: "unwindRecipeDelete", sender: self)
            default: break
            }
               // otherwise, do something else

            //self.performSegue(withIdentifier: "unwindFromHouseDelete", sender: self)
    
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Return false if you do not want the specified item to be editable.
        let alert = UIAlertController(title: "Delete Item?",
                                      message: "\(list.Items[indexPath.row])",
            preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            //Set new numItems
            self.list.numItems -= 1
            
            //Delete from Items
            self.list.Items.remove(at: indexPath.row)
            
            //post list to DB
            self.postList()
            self.tableView.reloadData()

        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        
        
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func DoneTapped(_ sender: Any) {
        if self.type == 1{
            self.performSegue(withIdentifier: "unwindShopping", sender: self)
        }
        if self.type == 0{
            self.performSegue(withIdentifier: "unwindHouse", sender: self)
        }
        if self.type == 2{
            self.performSegue(withIdentifier: "unwindRecipe", sender: self)
        }
    }
    
}
