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
        
        let userName = userNameTextField.text
        let userPassowrd = userPasswordTextField.text
        
        // Check if required field are empty
        
        if (userName?.isEmpty)! || (userPassowrd?.isEmpty)! {
            // Display alert message
            displayMessage(userMessage: "One of the required fiels is missing.")
            return
        }
    
        // Create activity indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position activity indicator
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent activity indicator from hidding  when stopAnimation() is called
        myActivityIndicator.hidesWhenStopped =  false
        
        // Start Activity indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        // Send URL request to Register  user
        let url = URL(string: "http://durtik.sk/api/authenticatin")
        
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["userName": userName!,
                          "userPassword": userPassowrd!
            ] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again.")
            return
        }
        
        
        
        let task = URLSession.shared.dataTask(with: request) {(data: Data?, response:URLResponse?, error:Error?) in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil {
                
                self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                print("error = \(String(describing: error))")
                return
            }
            
            // Let's convert response sent from server side  code to NSDictionary object:
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    // Now we can access value of first name by its key
                    let accessToken = parseJSON["token"] as? String
                    let userId = parseJSON["userId"] as? String
                    
                    print("accsessToken: \(String(describing: accessToken!))")
                    print("userId: \(String(describing: userId!))")
                    
                    
                    if (accessToken?.isEmpty)! {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later. ")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let homePage =
                        self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                        let appDelegate = UIApplication.shared.delegate
                        appDelegate?.window??.rootViewController = homePage
                        
                    }
                    
                    
                    /*
                    if (userId?.isEmpty)! {
                        self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                    } else {
                        self.displayMessage(userMessage: "Saccessuflly registered a new Account. Please proceed to Sign in ")
                    }
                    */
                } else {
                    self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                }
                
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                print(error)
                
            }
        }
        task.resume()
        
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("register New Account Button Tapped")
        
        let registerUserViewController =
        self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        
        self.present(registerUserViewController, animated: true)

    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OkAction = UIAlertAction(title: "OK", style: .default)
            {
                (action:UIAlertAction) in
                print("Ok button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            alertController.addAction(OkAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
