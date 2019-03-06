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
struct UserLists{
    
    let userID: String
    let email: String
    var numLists: Int
    var listNames: [String]
    var listIDs: [String]
    
    init(userID: String, email: String) {

        self.email = email
        self.userID = userID
        self.numLists = 0
        self.listNames = [String]()
        self.listIDs = [String]()
        
    }
    
    
    init?(snapshot: DataSnapshot) {

        guard
            let value = snapshot.value as? [String: AnyObject],
            let userID = value["userID"] as? String,
            let email = value["email"] as? String,
            let numLists = value["numLists"] as? Int else{
                return nil
        }
        self.userID = userID
        self.email = email
        self.listNames = [String]()
        self.listIDs = [String]()
        self.numLists = numLists
        
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
            "userID": userID,
            "numLists": numLists,
            "ListNames": listNames,
            "email": email,
            "ListIDs": listIDs
            
        ]
    }
    
    
}
