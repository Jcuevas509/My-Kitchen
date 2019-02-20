//
//  FriendRequestsViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/19/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase
class FriendRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    

    var ref: DatabaseReference!
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    var curUser : UserEntry!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
        }
        ref = Database.database().reference()
        LoadUser()
        super.viewDidLoad()

        
        
        navigationItem.title = "Friend Requests"
  
        
        
        // Do any additional setup after loading the view.
    }
    

 
 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if curUser == nil {
            return 0
        }
        else{
            return self.curUser.numRequests
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath)
        
        //do work
        cell.textLabel?.text = curUser.friendRequests[indexPath.row]
        return cell
    }
    
    // Override to support conditional editing of the table view.
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // Return false if you do not want the specified item to be editable.
       //RecipeName = RecipeNames[indexPath.row]
        //selectedAutoID = AutoIDs[RecipeName]!
        
        //performSegue(withIdentifier: "toRecipeView", sender: nil)
        let alert = UIAlertController(title: "Friend Request", message: "Do you wish to add this friend?", preferredStyle: .alert)
        
        let AddAction = UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: {
            (_)in
            //remove friend request
            self.curUser.numRequests -= 1
            let request = self.curUser.friendRequests[indexPath.row]
            print("request from : \(request)")
            self.curUser.friendRequests.remove(at: indexPath.row)
            print(self.curUser.friendRequests as Any)
            
           
            //add friend to cur User
            self.curUser.roomates.append(request)
            self.curUser.numRoomates += 1
            
            //update user
            self.ref.child("users").child((self.currentUser?.uid)!).setValue(self.curUser.toAnyObject())
            
            
            //add friend request to other user
            let nRequest = request.replacingOccurrences(of: ".", with: ";")
            self.ref.child("Email-UID").child(nRequest).observeSingleEvent(of: .value) {
                (snapshot) in
                
                guard let fUID = snapshot.value as? String else {
                    return
                }
                //Add the request to the other user
                self.ref.child("users").child(fUID).observeSingleEvent(of: .value) {
                    (snapshott) in
                    if var friendEntry = UserEntry(snapshot: snapshott) {
                        
                        //remove request
                        friendEntry.numPending -= 1
                        friendEntry.pendingRequests.removeAll { $0 == "\(self.curUser.email)" }
                        
                        //add roomate to roomates
                        friendEntry.numRoomates += 1
                        friendEntry.roomates.append(self.curUser.email)
                        
                        //write this data back to databse
                        self.ref.child("users").child(fUID).setValue(friendEntry.toAnyObject())
                        
                    }
                }
            }
        })
        let deleteAction = UIAlertAction(title: "Delete Request", style: .destructive, handler: {
            (_)in
            //do something
        })
       
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(AddAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
 
    }
    func LoadUser(){
        //Load Items
        let dir = self.currentUser?.uid
        print(dir!)
        self.ref.child("users").child(dir!).observeSingleEvent(of: .value) {
            (snapshot) in

            if let actualContent = UserEntry(snapshot: snapshot) {
                self.curUser = actualContent
                self.tableview.reloadData()
            }
            
        }
    }
}
