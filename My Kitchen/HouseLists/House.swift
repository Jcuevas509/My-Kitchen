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
struct HouseEntry{
    
    
    
    let ref: DatabaseReference?
    let key: String
    let houseID: String
    var numMembers: Int
    var members: [String]
    var numItems: Int
    var Items: [String]
    
    
    init(houseID: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.houseID = houseID
        self.numMembers = 0
        self.numItems = 0
        self.members = [String]()
        self.Items = [String]()
    }
    
  
    init?(snapshot: DataSnapshot) {
        //print(snapshot.key)
        //print(snapshot.value!)
        //let valu = snapshot.value as? [String: AnyObject]
        //print(valu!["friendRequests"]!)
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let houseID = value["houseID"] as? String,
            let numMembers = value["numMembers"] as? Int,
            let numItems = value["numItems"] as? Int else{
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.houseID = houseID
        self.numMembers = numMembers
        self.numItems = numItems
        self.members = [String]()
        self.Items = [String]()
        if numItems > 0 {
            if let items = value["Items"] as? [String]{
                self.Items = items
            }
            
        }
        if numMembers > 0 {
            if let members = value["Members"] as? [String]{
                self.members = members
            }
            
        }
        
    }
    
    func toAnyObject() -> Any {
        return [
            "houseID": houseID,
            "numMembers": numMembers,
            "numItems": numItems,
            "Members": members,
            "Items": Items
        ]
    }
    
    
}
