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
    var ListNames: [String] = ([])
    var selectedCell:Int = 0
    var CellName:String = ""
    var selectedAutoID:String = ""
    var AutoIDsD: [String: String] = ([:])
    override func viewDidLoad() {
        super.viewDidLoad()

        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
        }
        
        //set Database reference
         ref = Database.database().reference()
        
        fetchNewAdds()
        
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
        return ListNames.count
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Return false if you do not want the specified item to be editable.
        CellName = ListNames[indexPath.row]
        selectedAutoID = AutoIDsD[CellName]!
        
        performSegue(withIdentifier: "toListView", sender: nil)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "toListView"){
            //print(ListNames[selectedCell])
            //This way since im going into a NavigationControllor
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! GroceryListTableViewController
            targetController.listName = CellName
            targetController.autoID = selectedAutoID
           
        
        }
    }
    @IBAction func AddListsClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Create new list",
                                      message: "Enter list name",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            let nameField = alert.textFields![0]
            self.CellName = nameField.text!
            //Save to Database
            //Save to List-Names
            self.ref = self.ref.child("user-lists").child(self.currentUser!.uid).child("List-Names").childByAutoId()
            let autoID = self.ref.key
            
            self.selectedAutoID = autoID!
            self.ref.setValue(nameField.text)
            
            
            //bring back reference pointer
            self.ref = Database.database().reference()
           //Save to Shopping-Lists
            let data: GroceryItem = GroceryItem.init(name: self.CellName, numItems: 0, Items: [:])
            
            self.ref.child("user-lists").child(self.currentUser!.uid).child("Shopping-Lists").child(autoID!).child(autoID!).setValue(data.toAnyObject())

            self.performSegue(withIdentifier: "toListView", sender: nil)
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
        cell.textLabel?.text = ListNames[indexPath.row]
        //cell.textLabel?.text = quizData[indexPath.row]
        
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
     
     
        return true
    }
    

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
    @IBAction func unwindFromDone(sender: UIStoryboardSegue) {
        /*if let sourceViewController = sender.source as? GroceryListTableViewController {
        
                //let dataBack = sourceViewController.listName
        }*/
    }
    @IBAction func unwindTFromDelete(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? GroceryListTableViewController {
            let dataBack = sourceViewController.listName
            if let index = self.ListNames.index(of: dataBack) {
                self.ListNames.remove(at: index)
            }
            self.tableView.reloadData()
            
            
        }
    }
    func fetchNewAdds(){
        ref.child("user-lists").child((self.currentUser?.uid)!).child("List-Names").observe(.childAdded, with: { (snapshot) -> Void in
        
            
            let content = snapshot.value as? (String)
            if let actualContent = content {
                self.ListNames.append(actualContent)
                self.AutoIDsD[actualContent] = snapshot.key
                self.tableView.reloadData()
            }
            
        })
    }

}
