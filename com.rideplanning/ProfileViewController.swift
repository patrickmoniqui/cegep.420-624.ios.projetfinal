//
//  ProfileViewController.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-29.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let userService = UserService()
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnLogoff: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        userService.GetLoggedUser(completionHandler: { (user) in
            self.Load(user: user)
        })
        
    }
    
    func Load(user: UserViewModel)
    {
        lblUsername.text = user.username
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let userService = UserService()
        let Token = userService.GetToken()

        
        // If Token still valid
        if Token == nil || (Token?.ExpiresOn)! < Date()
        {
            userService.DeleteToken()
            self.performSegue(withIdentifier: "LoginViewSegue", sender: self)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func btnLogoff_Click(_ sender: Any){
        let userService = UserService()
        userService.DeleteToken()
        
        performSegue(withIdentifier: "LoginViewSegue", sender: sender)
    }

}
