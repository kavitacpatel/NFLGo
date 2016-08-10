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
import TwitterKit
import GoogleSignIn
import Google

class ViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInDelegate, GIDSignInUIDelegate
{
    var url: URL!
    //var FBRef = FIRFacebookAuthProviderID(
   
    var userNM: String = "User"
    var provider: String = ""
    var ref: FIRDatabaseReference?
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwTxt: UITextField!
    @IBOutlet weak var fbLoginBtn: FBSDKLoginButton!
       
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().clientID = "726127523868-pllbcge2319hhn9onnuc22g03icn4itn.apps.googleusercontent.com"
    
        let Base_URL: String = "https://nflgo-ee282.firebaseio.com/"
        ref = FIRDatabase.database().reference(fromURL: Base_URL)
        getUser()
        emailTxt.text = ""
        pwTxt.text = ""
        fbLoginBtn.readPermissions = ["public_profile"]
        fbLoginBtn.delegate = self
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
    }
    func getUser()
    {
        if FIRAuth.auth()?.currentUser != nil
        {
            self.provider = "email"
            if FIRAuth.auth()?.currentUser?.displayName != nil
            {
                userNM = (FIRAuth.auth()?.currentUser?.displayName)!
            }
            if FIRAuth.auth()?.currentUser?.email != nil
            {
                    userNM = (FIRAuth.auth()?.currentUser?.email)!
    
            }
            
            //let photoUrl = user.photoURL
            //print(user.uid)
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
        else
        {
            print("No user is signed in.")
        }

    }
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailSegue"
        {
            let vc = (segue.destinationViewController as! UITabBarController)
            let destinationViewController = vc.viewControllers![0] as! DetailViewController
            destinationViewController.user = userNM
            
        }
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    func keyboardWillShow(sender: NSNotification)
    {
        self.view.frame.origin.y -= 150
    }
    func keyboardWillHide(sender: NSNotification)
    {
        self.view.frame.origin.y += 150
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        textField.resignFirstResponder()
    }
    @IBAction func CreatAccount(_ sender: AnyObject)
    {
        if FIRAuth.auth()?.currentUser != nil
        {
           try! FIRAuth.auth()?.signOut()
        }
            FIRAuth.auth()?.createUser(withEmail: emailTxt.text!, password: pwTxt.text!) { (user, error) in
            
                if error != nil
                {
                
                if let errCode = FIRAuthErrorCode(rawValue: error!.code)
                {
                    
                    switch errCode
                    {
                    case .errorCodeInvalidEmail:
                        self.showalert("Email Login Error", msg: "Invalid Email or Password.")
                    case .errorCodeEmailAlreadyInUse:
                        self.showalert("Email Login Error", msg: "This email is in use.")
                    default:
                        self.showalert("Email Login Error", msg: error.debugDescription)
                    }
                    
                }
                
            }
            else
            {
                
                print("all good... continue")
                
                // self.performSegue(withIdentifier: "DetailSegue", sender: self)
                self.getUser()
            }
        }
    }
    @IBAction func emailLogin_Pressed(_ sender: AnyObject)
    {
        if FIRAuth.auth()?.currentUser != nil
        {
            try! FIRAuth.auth()?.signOut()
        }
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
                
               // self.performSegue(withIdentifier: "DetailSegue", sender: self)
                self.getUser()
            }
        })
        
    }
  
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error != nil
         {
            showalert("Facebook Login Error", msg: error.localizedDescription)
        }
        else
         {
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name,last_name"]).start { (connection, result, error) -> Void in
        
            if error != nil
            {
                print(error)
            }
            else
            {
             self.userNM = (result?.value(forKey: "first_name") as! String) + " " + (result?.value(forKey: "last_name")! as! String)
             self.performSegue(withIdentifier: "DetailSegue", sender: self)
            }
                
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        
    }
   
    @IBAction func twitterLogin_Pressed(_ sender: AnyObject)
    {
        Twitter.sharedInstance().logIn(withMethods: .all) { (session: TWTRSession?, err: NSError?) in
            if (session != nil)
            {
                //print("signed in as \(session?.userName)")
                self.userNM = (session?.userName)!
                self.performSegue(withIdentifier: "DetailSegue", sender: self)
            } else
            {
                print("error: \(err?.localizedDescription)")
            }
        }
        
    }
   
    @IBAction func googleLogin_Pressed(_ sender: AnyObject)
    {
       if GIDSignIn.sharedInstance().currentUser != nil
       {
            userNM = GIDSignIn.sharedInstance().currentUser.profile.email
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
        }
         GIDSignIn.sharedInstance().signIn()
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: NSError!)
    {
        if error != nil
        {
            showalert("Google Login Error", msg: error.localizedDescription)
        }
        else
        {
            userNM = user.profile.email
            self.performSegue(withIdentifier: "DetailSegue", sender: self)
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


