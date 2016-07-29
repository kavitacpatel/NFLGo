//
//  DataService.swift
//  NFLGo
//
//  Created by kavita patel on 7/25/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

let shadowcolor: CGFloat = 157.0/255.0
let KEY_UID = "uid"
let Seque_loggedin = "loggedin"
let USER_NO_EXISTS = -8
let URL_BASE = "https://nflgo.firebaseio.com/"
class DataService
{
    static var ds = DataService()
    
    private var _REF_BASE = FIRDatabase.database().reference(fromURL: URL_BASE)
    //private var _REF_POSTS = FIRDatabase.database().reference(fromURL: URL_BASE)
    //private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: FIRDatabaseReference
    {
        return _REF_BASE
    }
   }
