//
//  BetweenViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/30/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class BetweenViewController: UIViewController {

    @IBOutlet weak var studentSATTextField: UITextField!
    @IBOutlet weak var studentSATSubmitButton: UIButton!
    @IBOutlet weak var betweenControllerLabel: UILabel!

    // this is needed to transfer the university data to the next view
    var betweenViewControllerSelectedUniversity:UniversityData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // put the text for the label and adjust the size.
        self.betweenControllerLabel.text = "You have indicated that you are interested in \(betweenViewControllerSelectedUniversity!.UniversityName)."
        self.betweenControllerLabel.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToResultView") {
            let resultVC:UINavigationController = segue.destinationViewController as! UINavigationController;
            resultVC.studentSAT = studentSATTextField.text
        }
    }*/
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToNavigationControllerThree" {
            
            // get the new view controller using segue.destinationViewController.
            let DestinationNavigationViewControllerThree = segue.destinationViewController as! UINavigationController
            let targetResultViewController = DestinationNavigationViewControllerThree.topViewController as! ResultViewController
            
            // pass the selected studentSAT and university objects to the new view controller.
            targetResultViewController.studentSAT = studentSATTextField.text
            targetResultViewController.resultViewControllerSelectedUniversity = betweenViewControllerSelectedUniversity
        }
        
    }

}
