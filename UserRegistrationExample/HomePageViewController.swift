//
//  HomePageViewController.swift
//  UserRegistrationExample
//
//  Created by Slavomír Ďurta on 27.12.17.
//  Copyright © 2017 com.durta. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


class HomePageViewController: UIViewController {

    
    @IBOutlet weak var userFullNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButonTapped(_ sender: Any) {
      
        
        /* let removeAccessTokenSuccessful: Bool */
        _ = KeychainWrapper.standard.remove(key: "accessToken")
        /* let removeUserIdSuccessful: Bool  */
        _ = KeychainWrapper.standard.remove(key: "userId")
        
        let signInPage =
            self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
        
    }
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        loadMemberProfile()
    }
    
    
    func loadMemberProfile() {
        
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let userId: String? = KeychainWrapper.standard.string(forKey: "userId")
        
        
        // Send URL request to Register  user
        let url = URL(string: "http://durtik.sk/api/users/\(String(describing: userId))")
        var request = URLRequest(url:url!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
         let task = URLSession.shared.dataTask(with: request) {(data: Data?, response:URLResponse?, error:Error?) in
            
            if error != nil {
                
                self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                print("error = \(String(describing: error))")
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    DispatchQueue.main.async {
                        let firstName: String? = parseJSON["firstName"] as? String
                        let lastName: String? = parseJSON["lastName"] as? String
                        
                        if firstName?.isEmpty != true && lastName?.isEmpty != true {
                            self.userFullNameLabel.text = firstName! + " " + lastName!
                        }
                    }
                    
                } else {
                    self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                }
                
                
            } catch {
               
                self.displayMessage(userMessage: "Could not successfully  perform this request. Please try again later. ")
                print(error)
                
            }
        }
        task.resume()
        
        
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
