//
//  RegisterUserViewController.swift
//  UserRegistrationExample
//
//  Created by Slavomír Ďurta on 27.12.17.
//  Copyright © 2017 com.durta. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("cancelButtonTapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    

    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        
        print("signUpButtonTapped")
        
        // Validate required text fields are not empty
        
        if (firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (emailAddressTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (repeatTextField.text?.isEmpty)! {
            // Display alert message
            displayMessage(userMessage: "All field are required to fill in")
            return
        }
        
        // Validate password
        
        if passwordTextField.text?.elementsEqual(repeatTextField.text!) != true {
            displayMessage(userMessage: "Please make sure that password match")
              // Display alert message and return
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
        let url = URL(string: "http://durtik.sk")
        var request = URLRequest(url:url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["firstName": firstNameTextField.text,
                          "lastName": lastNameTextField.text,
                          "userName": emailAddressTextField.text,
                          "userPassword": passwordTextField.text
            ] as! [String: String]
        
        
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
                
                    let userId = parseJSON["userId"] as? String
                    print("userId: \(String(describing: userId!))")
                    if (userId?.isEmpty)! {
                         self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                    } else {
                         self.displayMessage(userMessage: "Saccessuflly registered a new Account. Please proceed to Sign in ")
                    }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
