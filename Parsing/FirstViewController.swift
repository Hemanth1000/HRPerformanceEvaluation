//
//  FirstViewController.swift
//  Parsing
//
//  Created by Apple on 26/08/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import QuartzCore

class FirstViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.font = UIFont.boldSystemFont(ofSize: 42.0)
        loginButton.layer.cornerRadius = 10
//        loginButton.layer.borderWidth = 1
        loginButton.clipsToBounds = true
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login")!)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
