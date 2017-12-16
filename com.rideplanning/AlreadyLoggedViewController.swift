//
//  AlreadyLoggedViewController.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import UIKit

class AlreadyLoggedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnLogoff_Click(_ sender: Any) {
        let userService = UserService()
        userService.DeleteToken()
        
        self.performSegue(withIdentifier: "LogoffSegue", sender: self)
    }
}
