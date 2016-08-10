//
//  Dataservice.swift
//  NFLGo
//
//  Created by kavita patel on 8/1/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//
import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    var BASE_URL: String = "https://nflgo.firebaseio.com/"

    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _Img_REF = Firebase(url: "\(BASE_URL)/jokes")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    var Img_REF: Firebase {
        return _Img_REF
    }
}
