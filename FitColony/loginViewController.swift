//
//  loginViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/10.
//  Copyright © 2016年 li. All rights reserved.
//


import UIKit
import AVOSCloud


class loginViewController: UIViewController {
    var registerVC:registerViewController?
    var flag = 1
    
    
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBAction func clickLogin(sender: AnyObject) {
        let username=inputUsername.text
        let password=inputPassword.text
        
        AVUser.logInWithUsernameInBackground(username, password: password, block: {(user:AVUser?,error:NSError?) in
            if ((user) != nil){
                let sele=HDprofile.query()
                sele.whereKey("user", equalTo: user)
                if sele.getFirstObject()==nil{
                    self.performSegueWithIdentifier("firstloginSegue", sender: self)
                }else{
                    
                    self.performSegueWithIdentifier("LogintoMain", sender: self)
                }
                
            }else{
                print(error?.domain)
                print(error?.code)
            }
        
        
        })

    }
    @IBAction func forgetPassword(sender: AnyObject) {
        self.performSegueWithIdentifier("forgetpasswordSegue", sender: self)
    }
    @IBAction func gotoRegister(sender: AnyObject) {
       
        self.performSegueWithIdentifier("LogintoRegister", sender: self)
    }
    
    
    override func viewDidLayoutSubviews() {
        let user = AVUser.currentUser()
        if (user != nil)&&(flag == 1) {
            let sele=HDprofile.query()
            sele.whereKey("user", equalTo: user)
            if sele.getFirstObject()==nil{
                
                self.performSegueWithIdentifier("firstloginSegue", sender: self)
                flag = 0
            }else{
                
                self.performSegueWithIdentifier("LogintoMain", sender: self)
                flag = 0
            }

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPassword.secureTextEntry=true
        flag = 1
        NSThread.sleepForTimeInterval(2.0)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}