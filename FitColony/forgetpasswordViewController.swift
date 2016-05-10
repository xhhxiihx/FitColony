//
//  forgetpasswordViewController.swift
//  FitColony
//
//  Created by 李方然 on 16/3/14.
//  Copyright © 2016年 li. All rights reserved.
//

import UIKit
import AVOSCloud

class forgetpasswordViewController: UIViewController {

    @IBAction func backbtn(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var resetpasswordtips: UILabel!
    @IBOutlet weak var findpasswordButton: UIButton!
    
    @IBOutlet weak var email: UITextField!
    @IBAction func findpassword(sender: AnyObject) {
        let emailad = email.text
        if emailad==""{
            
        }else{
            AVUser.requestPasswordResetForEmailInBackground(emailad)
            email.hidden=true
            resetpasswordtips.hidden=false
            resetpasswordtips.text="我们已经发送密码重置链接到你的邮箱:\n \(emailad!) \n 现在你可以打开邮件设置一个新的密码了"
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        resetpasswordtips.hidden=true
        email.hidden=false
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
