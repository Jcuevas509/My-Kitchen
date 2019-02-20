//
//  RecipeViewTableViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/6/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase
class RecipeViewTableViewController: UITableViewController {

    var Items:[String] = []
    var Item: Recipe!
    var RecipeName: String = ""
    var autoID: String = ""
    
    var ref: DatabaseReference!
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = RecipeName
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
            
        }
        //set Database reference
        ref = Database.database().reference()
        
        LoadItems()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = Items[indexPath.row]
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func LoadItems(){
        //Load Items
        ref.child("users").child((self.currentUser?.uid)!).child("Recipe-Items").child(autoID).observe(.childAdded, with: { (snapshot) -> Void in
            
            
            print(snapshot.key)
            print(snapshot.value as Any)
            if let actualContent = Recipe(snapshot: snapshot) {
                self.Item = actualContent
                for (_, itemName) in actualContent.Items{
                    self.Items.append(itemName)
                }
                self.tableView.reloadData()
            }
            
            
            
        })
    }
    @IBAction func AddTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Recipe Ingedients",
                                      message: "Enter ingredient",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let nameField = alert.textFields![0]
            
            let autoIDkey = self.ref.child("user-lists").child(self.currentUser!.uid).child("Recipe-Items").child(self.autoID).child(self.autoID).child("Items").childByAutoId().key
            let newRef = self.ref.child("user-lists").child(self.currentUser!.uid).child("Recipe-Items").child(self.autoID).child(self.autoID)
            
            if self.Item == nil{ //Empty make new one
                self.Item = Recipe.init(name: self.RecipeName, numItems: 1, Items: [autoIDkey! : nameField.text!])
            }
            else{ //Items exists, must update
                self.Item.numItems += 1
                //update ItemLists
                
                self.Item.Items[autoIDkey!] = nameField.text
                
                
            }
            
            
            newRef.setValue(self.Item.toAnyObject())
            self.Items.append(nameField.text!)
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
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Return false if you do not want the specified item to be editable.
        let alert = UIAlertController(title: "Delete Item?",
                                      message: "\(Items[indexPath.row])",
            preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            //let nameField = alert.textFields![0]
            //get key value
            var indexKey : String = ""
            let itemName = self.Items[indexPath.row]
            for (key, value) in self.Item.Items{
                if value == itemName{
                    indexKey = key
                    break
                }
                
            }
            
            self.Item.Items[indexKey] = nil
            self.Item.numItems -= 1
            if let index = self.Items.index(of: itemName) {
                self.Items.remove(at: index)
            }
            let newRef = self.ref.child("user-lists").child(self.currentUser!.uid).child("Recipe-Items").child(self.autoID).child(self.autoID)
            newRef.setValue(self.Item.toAnyObject())
            self.tableView.reloadData()
            
            
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        
        
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func DeleteRecipeTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to delete this Recipe?",
                                      message: "This action cannot be undone.",
                                      preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
   
            var newRef = self.ref.child("user-lists").child(self.currentUser!.uid).child("Recipe-Items").child(self.autoID).child(self.autoID)
            newRef.setValue(nil)
            newRef = Database.database().reference()
            newRef = self.ref.child("user-lists").child(self.currentUser!.uid).child("Recipe-Names").child(self.autoID)
            newRef.setValue(nil)
            
            self.performSegue(withIdentifier: "unwindFromDeleteRecipe", sender: self)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
 
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}
