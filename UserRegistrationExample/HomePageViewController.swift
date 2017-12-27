//
//  HomePageViewController.swift
//  UserRegistrationExample
//
//  Created by Slavomír Ďurta on 27.12.17.
//  Copyright © 2017 com.durta. All rights reserved.
//

import UIKit

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
        print("signOutButonTapped")
    }
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        print("loadMemberProfileButtonTapped")

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
