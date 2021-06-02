//
//  HomeTabBarController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/2/21.
//

import UIKit
import Firebase

class HomeTabBarController: UITabBarController {

    private var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = #colorLiteral(red: 0.693454206, green: 0.6893339753, blue: 0.6966225505, alpha: 1)
        self.tabBar.clipsToBounds = true
        
        self.authListener = Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.performSegue(withIdentifier: "Logout", sender: self)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let authListener = authListener {
            print("view will disappear")
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
}
