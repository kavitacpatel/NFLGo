//
//  FBViewController.swift
//  NFLGo
//
//  Created by kavita patel on 8/1/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class FBViewController: UIViewController
{
    var ref: FIRDatabaseReference!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let Base_URL: String = "https://nflgo-ee282.firebaseio.com//"
        
        ref = FIRDatabase.database().reference(fromURL: Base_URL)
        ref.observe(.value, with: { snapshot in
            print(snapshot.value)
            }, withCancel: { error in
                print(error.description)
        })
    }
}

