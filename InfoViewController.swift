//
//  InfoViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 9/10/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var englishScrollView: UIScrollView!
    @IBOutlet weak var 中文ScrollView: UIScrollView!
    
    // get userdefaults for language
    let appUserDefaults = UserDefaults.standard
    var 中文:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set language
        中文 = appUserDefaults.bool(forKey: "language")
        
        switch 中文! {
        case false:
            self.backBarButtonItem.title = "Back"
            self.中文ScrollView.alpha = 0
            self.中文ScrollView.isUserInteractionEnabled = false
        case true:
            self.backBarButtonItem.title = "返回"
            self.englishScrollView.alpha = 0
            self.englishScrollView.isUserInteractionEnabled = false
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
