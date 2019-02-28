//
//  HouseListTableViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/20/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase

class HouseListTableViewController: UITableViewController {

    var House: HouseEntry!
    var ref: DatabaseReference!
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    var curUserEntry : UserEntry!
    var listNames: [String]!
    var selectedAutoId: String = String()
    
    override func viewDidLoad() {
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
        }
        //set Database reference
        ref = Database.database().reference()
        super.viewDidLoad()
        LoadUser()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.House == nil{
            return 0
        }
        return self.House.numLists
        
    }
    func LoadHouse(){
        //Load Items
        let dir = self.curUserEntry.houseKey
        
        
        ref.child("Houses").child("House-Info").child(dir).observeSingleEvent(of: .value) {
            (snapshot) in
            print(snapshot as Any)
            if let actualContent = HouseEntry(snapshot: snapshot) {
                self.House = actualContent
                self.tableView.reloadData()
                print("Got House")
            }
            
        }
    }
    func LoadUser(){
        //Load Items
        let dir = self.currentUser?.uid
        ref.child("users").child(dir!).observeSingleEvent(of: .value) {
            (snapshot) in
            if let actualContent = UserEntry(snapshot: snapshot) {
                self.curUserEntry = actualContent
                self.LoadHouse()
            }
            
        }
    }

    @IBAction func AddPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Create new list",
                                      message: "Enter list name",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            /*guard let nameField = alert.textFields![0] else {
                //show("No address to submit")
                print("Invalid input")
                return
            }*/
            let namefield = alert.textFields![0]
            guard let nameField = namefield.text else{
                return
            }
            if nameField == ""{
                return
            }
            //Save to Database
            guard let autoID = self.ref.child("Houses").child("House-Lists").childByAutoId().key else{
                return
            }
            
            self.selectedAutoId = autoID
            let newList: List = List.init(name: nameField, autoID: autoID)
            self.ref.child("Houses").child("House-Lists").child(autoID).setValue(newList.toAnyObject())
            
            self.House.listNames.append(nameField)
            self.House.listIDs.append(autoID)
            
            self.House.numLists += 1
            self.ref.child("Houses").child("House-Info").child(self.House.houseID).setValue(self.House.toAnyObject())
          
            self.performSegue(withIdentifier: "toHouseList", sender: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HouseCell", for: indexPath)

        // Configure the cell...

        print(indexPath.row)
        cell.textLabel?.text = self.House.listNames[indexPath.row]
        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Return false if you do not want the specified item to be editable.

        selectedAutoId = self.House.listIDs[indexPath.row]
        
        performSegue(withIdentifier: "toHouseList", sender: nil)
    }

    @IBAction func unwindFromHouseDone(sender: UIStoryboardSegue) {
        /*if let sourceViewController = sender.source as? GroceryListTableViewController {
         
         //let dataBack = sourceViewController.listName
         }*/
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "toHouseList"){
            //print(ListNames[selectedCell])
            //This way since im going into a NavigationControllor
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! ListTableViewController
            targetController.curUserEntry = self.curUserEntry
            targetController.autoID = selectedAutoId
            
        }
    }
}


