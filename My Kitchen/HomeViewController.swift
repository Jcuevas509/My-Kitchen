//
//  HomeViewController.swift
//  My Kitchen
//
//  Created by Jose Cuevas on 2/5/19.
//  Copyright © 2019 Jose Cuevas. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    
 
    var currentUser: User? = Auth.auth().currentUser
    var handle: AuthStateDidChangeListenerHandle!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.currentUser = user
            
            if user == nil {
                //UserDefaults.standard.setValue(false, forKey: UserDefaults.loggedIn)
                print("Not Logged in")
            } else {
                //UserDefaults.standard.setValue(true, forKey: UserDefaults.loggedIn)
                print("Logged Logged in")
            }
            
        }
        //nameLbl.text = 
        /*Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                
                print("User is signed in.")
            } else {
                print("User is signed out.")
            }
        }*/

        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBAction func ButtonClick(_ sender: Any) {
        
        print("Button Clicked")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
