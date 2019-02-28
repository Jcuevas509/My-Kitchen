//
//  GroceryItem.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/6/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase
struct List{
    
    
    
 
    let autoID: String
    let name: String
    var numItems: Int
    var Items: [String]
    
    init(name: String, autoID: String) {
        self.autoID = autoID
        self.name = name
        self.numItems = 0
        self.Items = [String]()
        
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let autoID = value["autoID"] as? String,
            let name = value["name"] as? String,
            let numItems = value["numItems"] as? Int else {
                print("failed")
                return nil
        }
        
        self.autoID = autoID
        self.name = name
        self.numItems = numItems
        self.Items = [String]()
        
        if numItems > 0 {
            if let Items = value["Items"] as? [String]{
                self.Items = Items
            }
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "autoID": autoID,
            "name": name,
            "numItems": numItems,
            "Items": Items
        ]
    }
    
    
}
