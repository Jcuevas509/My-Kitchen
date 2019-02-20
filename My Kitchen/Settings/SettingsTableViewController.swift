//
//  SettingsTableViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/12/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase



class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var RequestsCell: UITableViewCell!
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
        
        LoadUser()
        // 1
        
        //listener for friend requests
        let uid = self.currentUser?.uid
        let path = "users/\(uid ?? "")/friendRequests"
        let friendRef = Database.database().reference(withPath: path)

        friendRef.observe(.childAdded, with: { snap in
            // 2
            let friendReq = snap.value
            self.RequestsCell.detailTextLabel?.text = "!"
            print("requests \(friendReq ?? "")")
            //guard let email = snap.value as? String else { return }
            //self.currentUsers.append(email)
           
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let section = indexPath.section
        let row = indexPath.row
        print("Section: \(indexPath.section)\nRow: \(indexPath.row)")
        
        switch section {
        case 0:
            print("Number is 150")
        case 1:
            switch row {
            case 0:
                AddUserToHouse()
            case 1:
                ListRequests()
                print("YEAh")
            default:
                print("Otherwise, do something else.")
            }
            
        default:
            print("Otherwise, do something else.")
        }
    }
    func AddUserToHouse(){
        let alert = UIAlertController(title: "Add user to home",
                                      message: "Enter Email",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            
            let nameField = alert.textFields![0]
 
            let nEmail = nameField.text!.replacingOccurrences(of: ".", with: ";")
            
            //check if user exists
            self.ref.child("Email-UID").observeSingleEvent(of: .value) {
                (snapshot) in
                if snapshot.hasChild(nEmail){
                    
                    //add pending
                    self.curUserEntry.numPending += 1
                    self.curUserEntry.pendingRequests.append(nameField.text!)
                    
                    //update current user Entry to fix results
                    self.ref.child("users").child((self.currentUser?.uid)!).setValue(self.curUserEntry.toAnyObject())
                    
                    //add friend request to other user
                    self.ref.child("Email-UID").child(nEmail).observeSingleEvent(of: .value) {
                        (snapshot) in
                        
                        guard let fUID = snapshot.value as? String else {
                            return
                        }
                        //Add the request to the other user
                        self.ref.child("users").child(fUID).observeSingleEvent(of: .value) {
                            (snapshott) in
                            if var friendEntry = UserEntry(snapshot: snapshott) {
                                
                                //Now add the request inside
                                friendEntry.numRequests += 1
                                friendEntry.friendRequests.append(self.curUserEntry.email)
                                
                                //write this data back to databse
                                self.ref.child("users").child(fUID).setValue(friendEntry.toAnyObject())
                                
                            }
                        }
                    }
                    
                    
                    
                } else{return;}
            }
            

                
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textName in
            textName.placeholder = "Enter Email"
        }
        
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

 
    func ListRequests(){
        
    }
    
    func LoadUser(){
        //Load Items
        let dir = self.currentUser?.uid
        ref.child("users").child(dir!).observeSingleEvent(of: .value) {
            (snapshot) in
        
            
            if let actualContent = UserEntry(snapshot: snapshot) {
                self.curUserEntry = actualContent
                if self.curUserEntry.numRequests > 0{self.RequestsCell.detailTextLabel?.text = "!"}
            }
            
        }
    }
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
