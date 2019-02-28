//
//  User.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/13/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//
import Foundation
import UIKit
import Firebase
struct UserEntry{
    
    
    
    let ref: DatabaseReference?
    let key: String
    let email: String
    var houseKey: String
    var numRoomates: Int
    var numPending: Int
    var numRequests: Int
    var pendingRequests: [String]
    var roomates: [String]
    var friendRequests: [String]
    
    
    init(email: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.email = email
        self.numRoomates = 0
        self.numPending = 0
        self.numRequests = 0
        self.friendRequests = [String]()
        self.roomates = [String]()
        self.pendingRequests = [String]()
        self.houseKey = String()
    }
    
   /* init?(snapshot: DataSnapshot) {
        print(snapshot.key)
        print(snapshot.value!)
        //let valu = snapshot.value as? [String: AnyObject]
        //print(valu!["friendRequests"]!)
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let numRoomates = value["numRoomates"] as? Int,
            let numPending = value["numPending"] as? Int,
            let numRequests = value["numRequests"] as? Int,
            let friendRequests = value["friendRequests"] as? [String],
            let pendingRequests = value["pendingRequests"] as? [String],
            let roomates = value["roomates"] as? [String] else {
                return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.email = email
        self.numPending = numPending
        self.numRequests = numRequests
        self.numRoomates = numRoomates
        self.pendingRequests = pendingRequests
        self.friendRequests = friendRequests
        self.roomates = roomates
       
        
        /*for (key, value) in Items{
            self.Items[key] = value
        }
        //self.Items = Items*/
    }*/
    init?(snapshot: DataSnapshot) {
        print(snapshot.key)
        print(snapshot.value!)
        //let valu = snapshot.value as? [String: AnyObject]
        //print(valu!["friendRequests"]!)
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let email = value["email"] as? String,
            let houseKey = value["houseKey"] as? String,
            let numRoomates = value["numRoomates"] as? Int,
            let numPending = value["numPending"] as? Int,
            let numRequests = value["numRequests"] as? Int else{
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.email = email
        self.numPending = numPending
        self.numRequests = numRequests
        self.numRoomates = numRoomates
        self.houseKey = houseKey
        self.pendingRequests = [String]()
        self.friendRequests = [String]()
        self.roomates = [String]()
        if numRoomates > 0 {
            if let roomates = value["roomates"] as? [String]{
                self.roomates = roomates
            }
            
        }
        if numRequests > 0 {
            if let friendRequests = value["friendRequests"] as? [String]{
                self.friendRequests = friendRequests
            }
            
        }
        if numPending > 0 {
            if let pendingRequests = value["pendingRequests"] as? [String] {
                self.pendingRequests = pendingRequests
            }
        } 
        
        
        /*for (key, value) in Items{
         self.Items[key] = value
         }
         //self.Items = Items*/
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "numRoomates": numRoomates,
            "numRequests": numRequests,
            "numPending": numPending,
            "roomates": roomates,
            "friendRequests": friendRequests,
            "pendingRequests": pendingRequests,
            "houseKey": houseKey
        ]
    }
    
    
}
