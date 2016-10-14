//
//  NavigationToDataTableViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 10/3/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class NavigationToDataTableViewController: UINavigationController {

    @IBOutlet weak var savedSATUniversitiesBarItem: UITabBarItem!
    
    // get nsuserdefaults for language
    let appUserDefaults = UserDefaults.standard
    var 中文:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set language
        中文 = appUserDefaults.bool(forKey: "language")
        
        // Do any additional setup after loading the view.
        switch 中文! {
        case false:
            savedSATUniversitiesBarItem.title = "Saved Universities"
        case true:
            savedSATUniversitiesBarItem.title = "选择的大学"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
