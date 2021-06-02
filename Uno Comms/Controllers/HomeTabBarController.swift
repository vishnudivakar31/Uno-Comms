//
//  HomeTabBarController.swift
//  Uno Comms
//
//  Created by Vishnu Divakar on 6/2/21.
//

import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.borderWidth = 0.5
        self.tabBar.layer.borderColor = #colorLiteral(red: 0.693454206, green: 0.6893339753, blue: 0.6966225505, alpha: 1)
        self.tabBar.clipsToBounds = true
    }
}
