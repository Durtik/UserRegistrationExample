//
//  SignInViewController.swift
//  UserRegistrationExample
//
//  Created by Slavomír Ďurta on 27.12.17.
//  Copyright © 2017 com.durta. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign In button tapped")
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("register New Account Button Tapped")
        
        let registerUserViewController =
        self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        
        self.present(registerUserViewController, animated: true)

    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
