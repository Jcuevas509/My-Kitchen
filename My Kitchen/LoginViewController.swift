//
//  LoginViewController.swift
//  
//
//  Created by Jose Cuevas on 2/4/19.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    
    @IBOutlet weak var ErrorLbl: UILabel!
    @IBOutlet weak var EmailTF: UITextField!
    
    @IBOutlet weak var PasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Auth.auth().addStateDidChangeListener() { auth, user in
            
            if user != nil {
                
                self.EmailTF.text = nil
                self.PasswordTF.text = nil
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }*/

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard
            let email = EmailTF.text,
            let password = PasswordTF.text,
            email.count > 0,
            password.count > 0
            else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                print("Logged In")
                self.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { user, error in
                if error == nil {
                    //
                    
                  Auth.auth().signIn(withEmail: self.EmailTF.text!,
                                       password: self.PasswordTF.text!)
                    var ref: DatabaseReference!
                    var currentUser: User? = Auth.auth().currentUser
                    var handle: AuthStateDidChangeListenerHandle!
                    
                    handle = Auth.auth().addStateDidChangeListener { (auth, userr) in
                        currentUser = userr
                        ref = Database.database().reference()
                        
                        let nData: UserEntry = UserEntry.init(email: emailField.text!)
                        ref.child("users").child(currentUser!.uid).setValue(nData.toAnyObject())
                        
                        //add user to Email-UID
                        ref = Database.database().reference()
                        let nEmail = emailField.text!.replacingOccurrences(of: ".", with: ";")
                        
                        ref.child("Email-UID").child(nEmail).setValue(currentUser?.uid)
                        
                        let nUser: UserLists = UserLists.init(userID: (currentUser?.uid)!, email: (currentUser?.email)!)
                        ref.child("User-Lists").child((currentUser?.uid)!).child("User-S-Info").setValue(nUser.toAnyObject())
                        let nRUser: UserLists = UserLists.init(userID: (currentUser?.uid)!, email: (currentUser?.email)!)
                        ref.child("User-Lists").child((currentUser?.uid)!).child("User-R-Info").setValue(nRUser.toAnyObject())
                    }
                    self.performSegue(withIdentifier: "toHome", sender: nil)
                    
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
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
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == EmailTF {
            PasswordTF.becomeFirstResponder()
        }
        if textField == PasswordTF {
            textField.resignFirstResponder()
        }
        return true
    }
}
