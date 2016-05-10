//
//  registerViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/10.
//  Copyright © 2016年 li. All rights reserved.
//


import UIKit
import AVOSCloud

class registerViewController: UIViewController {
    let newUser=AVUser()
    
    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBAction func backtologin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func uploadRegister(sender: AnyObject) {
        newUser.username=inputUsername.text
        newUser.password=inputPassword.text
        newUser.email=inputEmail.text
        newUser.signUpInBackgroundWithBlock({(succeeded: Bool, error: NSError?) in
            if  (succeeded){
                
                let newuserProfile = UserProfile()
                newuserProfile.user = AVUser.currentUser()
                newuserProfile.name = self.newUser.username
                newuserProfile.area = "未知"
                newuserProfile.avartar = nil
                newuserProfile.brief = ""
                newuserProfile.save()
                self.alert("注册成功")
            }else{
//                print("no")
//                print(error?.domain)
//                print(error?.code)
            }
        })
    }
    
    func alert(text:String){
        let alertController = UIAlertController(title: "提示", message: text, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
           self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputPassword.secureTextEntry=true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}