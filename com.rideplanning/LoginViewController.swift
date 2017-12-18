//
//  LoginViewController.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblErr: UILabel!
    
    var overlay : UIView?
    
    var userService: UserService = UserService()
    
    override func viewDidLoad() {
        self.lblErr.text = ""
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let Token = userService.GetToken()
        
        // If Token still valid
        if Token != nil && (Token?.ExpiresOn)! > Date() {
            self.performSegue(withIdentifier: "MainViewSegue", sender: self)
        }
        else if Token != nil && (Token?.ExpiresOn)! < Date()
        {
           userService.DeleteToken()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ValidateForm() -> Bool
    {
        var IsValid: Bool = true;
        
        let username = txtUsername.text!
        let password = txtPassword.text!

        if(username == "")
        {
            lblErr.text = lblErr.text! + "\nPlease enter a username."
            IsValid = false
        }
        
        if(password == "")
        {
            lblErr.text = lblErr.text! + "\nPlease enter a password."
            IsValid = false
        }
        
        return IsValid
    }
    
    func OnLoading(IsLoading: Bool)
    {
        if IsLoading {
            overlay = UIView(frame: view.frame)
            overlay!.backgroundColor = UIColor.black
            overlay!.alpha = 0.8
            
            let label = UILabel()
            label.textColor = UIColor.white
            label.textAlignment = NSTextAlignment.center
            label.text = "Authentificating..."
            
            overlay?.inputView?.addSubview(label)
            
            view.addSubview(overlay!)
        }
        else
        {
            overlay?.removeFromSuperview()
        }
    }
    

    /* Event Handlers */
    
    @IBAction func btnLogin_Click(_ sender: Any) {
        if(ValidateForm())
        {
            let username = txtUsername.text!
            let password = txtPassword.text!

            OnLoading(IsLoading: true)
            
            userService.Login(username: username, password: password, completionHandler: { (token) in
                self.OnLoading(IsLoading: false)
                
                if(token != nil)
                {
                    self.lblErr.text = ""
                    self.performSegue(withIdentifier: "MainViewSegue", sender: self)
                }
                else
                {
                    self.lblErr.text = "Invalid credentials."
                }
            })
        }
    }
    
    @IBAction func btnBrowseGuess_Click(_ sender: Any) {
        self.performSegue(withIdentifier: "GuessSegue", sender: self)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "MainViewSegue" {
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
            }
        }
        
        if segue.identifier == "GuessSegue"
        {
            if let tabVC = segue.destination as? UITabBarController{
                tabVC.selectedIndex = 0
            }
        }
    }
}
