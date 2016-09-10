//
//  InfoViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 9/10/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var infoviewText: UIScrollView!
    @IBOutlet weak var infoViewScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var scrollableSize = CGSizeMake(0, 0)
        //infoViewScrollView.contentSize = scrollableSize

        // Do any additional setup after loading the view.
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
