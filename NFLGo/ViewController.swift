//
//  ViewController.swift
//  NFLGo
//
//  Created by kavita patel on 7/22/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit


class ViewController: UIViewController
{
    var Base_URL: String = "https://nflgo.firebaseio.com/"
    var url: URL!
   // var FBRef = Firebase()
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwTxt: UITextField!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(fromURL: Base_URL)
        emailTxt.text = ""
        pwTxt.text = ""
       // ref.setValue("Do you have data? You'll love Firebase.")
        
    }
    @IBAction func CreatAccount(_ sender: AnyObject)
    {
        FIRAuth.auth()!.createUser(withEmail: emailTxt.text!, password: pwTxt.text!) { (user, error) in
          if error != nil
          {
            self.showalert("Email Login Error", msg: "Invalid User name or Password.")
          }
           else
          {
            print("successfully Created new account")
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
          }
        }
    }
    @IBAction func emailLogin_Pressed(_ sender: AnyObject)
    {
        FIRAuth.auth()!.signIn(withEmail: self.emailTxt.text!, password: self.pwTxt.text!, completion: { (user:FIRUser?, err:NSError?) in
            if err != nil
            {
                if err?.code == 17011
                {
                    self.showalert("Email Login Error", msg: "User not found.")
                }
                    else if err?.code == 17009
                {
                    self.showalert("Email Login Error", msg: "The password is invalid")
                }
                else if err?.code == 17999
                {
                    self.showalert("Email Login Error", msg: "Missing password.")
                }
                else
                {
                    self.showalert("Email Login Error", msg: "Email login failed. \(err)")
                }
            }
            else
            {
                print("successfully logged ")
                self.performSegue(withIdentifier: "DetailSegue", sender: self)
            }
        })
        
    }
    
    @IBAction func facebookLogin_Pressed(_ sender: AnyObject)
    {
        let facebooklogin = FBSDKLoginManager()
        facebooklogin.logIn(withReadPermissions: ["email"], from: self) { (result: FBSDKLoginManagerLoginResult?, err: NSError?) in
           if err != nil
            {
                self.showalert("Facebook Login Error", msg: "Facebook login failed \(err)")
            }
            else
            {
                //let accesstoken = FBSDKAccessToken.current().tokenString
                print("logged in fb")
                self.performSegue(withIdentifier: "DetailSegue", sender: self)
            }

        }
    }
    func showalert(_ title: String, msg:String)
    {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertaction)
        present(alert, animated: true, completion: nil)
        
    }

    
    }


