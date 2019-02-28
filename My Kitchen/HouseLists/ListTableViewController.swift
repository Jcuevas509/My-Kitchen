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
    
    var ref: DatabaseReference!
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    var curUserEntry : UserEntry!
    
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
        ref.child("Houses").child("House-Lists").child(self.autoID).observeSingleEvent(of: .value) {
            (snapshot) in
            if let actualContent = List(snapshot: snapshot) {
                self.list = actualContent
                self.navigationItem.title = self.list.name
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)

        // Configure the cell...

        cell.textLabel!.text = self.list.Items[indexPath.row]
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

}
