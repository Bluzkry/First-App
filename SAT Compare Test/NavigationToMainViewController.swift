//
//  NavigationToMainViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 10/3/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

protocol NavigationToMainViewControllerDelegate {
}

class NavigationToMainViewController: UINavigationController {

    @IBOutlet weak var mainTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        switch 中文 {
        case false:
            mainTabBarItem.title = "Main"
        case true:
            mainTabBarItem.title = "首页"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
