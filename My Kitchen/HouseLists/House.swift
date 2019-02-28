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
    var numLists: Int
    var members: [String]
    var listNames: [String]
    var listIDs: [String]
    
    init(houseID: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.houseID = houseID
        self.numLists = 0
        self.numMembers = 0
        self.members = [String]()
        self.listNames = [String]()
        self.listIDs = [String]()
        
    }
    
  
    init?(snapshot: DataSnapshot) {
        //print(snapshot.key)
        //print(snapshot.value!)
        //let valu = snapshot.value as? [String: AnyObject]
        //print(valu!["friendRequests"]!)
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let houseID = value["houseID"] as? String,
            let numLists = value["numLists"] as? Int,
            let numMembers = value["numMembers"] as? Int else{
                return nil
        }
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.houseID = houseID
        self.numMembers = numMembers
        self.members = [String]()
        self.listNames = [String]()
        self.listIDs = [String]()
        self.numLists = numLists
        if numMembers > 0 {
            if let members = value["Members"] as? [String]{
                self.members = members
            }
        }
        if numLists > 0 {
            if let listNames = value["ListNames"] as? [String]{
                self.listNames = listNames
                
            }
            if let listIds = value["ListIDs"] as? [String]{
                self.listIDs = listIds
                
            }
        }
        
    }
    
    func toAnyObject() -> Any {
        return [
            "houseID": houseID,
            "numMembers": numMembers,
            "Members": members,
            "numLists": numLists,
            "ListNames": listNames,
            "ListIDs": listIDs
        ]
    }
    
    
}
