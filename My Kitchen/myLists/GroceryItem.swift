//
//  GroceryItem.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/6/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase
struct GroceryItem{
    
    
    
    let ref: DatabaseReference?
    let key: String
    let name: String
    var numItems: Int
    var Items: [String: String]
    
    init(name: String, numItems: Int, Items : [String: String], key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.numItems = numItems
    self.Items = Items
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let numItems = value["numItems"] as? Int,
            let Items = value["Items"] as? [String : String] else {
                print("failed")
            return nil
        }
    
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.name = name
        self.numItems = numItems
        self.Items = [:]
        
        for (key, value) in Items{
            self.Items[key] = value
        }
    //self.Items = Items
    }
    
    func toAnyObject() -> Any {
    return [
    "name": name,
    "numItems": numItems,
    "Items": Items
    ]
    }
    

}
