	//
//  ResultViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/31/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet var resultViewControllerImageView: UIView!
    @IBOutlet weak var resultViewControllerLabel: UILabel!
    @IBOutlet weak var lowSATImageView: UIView!
    @IBOutlet weak var highSATImageView: UIView!
    // this image view is at the right and is for the positioning of the student label
    @IBOutlet weak var studentSATImageView: UIView!
    
    var backgroundSlider: UISlider! = UISlider()
    var universitySlider: UISlider! = UISlider()
    var twentyFivePercentileLabel: UILabel! = UILabel()
    var seventyFivePercentileLabel: UILabel! = UILabel()
    var studentSATLabel: UILabel! = UILabel()

    var studentSAT:String?
    var resultViewControllerSelectedUniversity:UniversityData!

    // this is needed at top for determining the student SAT percentile
    var studentSATPercentile:Int?
    
    override func viewDidLoad() {
    ////
    ////
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set sliders and labels
        self.setUniversitySlider()
        self.setBackgroundSlider()
        self.setSATImageViews()
        self.setTwentyFivePercentileLabel()
        self.setSeventyFivePercentileLabel()
        
        // we test if the student wrote a correct SAT score
        let studentSATInt:Int? = Int(studentSAT!)
        let selectedUniversityName = resultViewControllerSelectedUniversity.UniversityName
        
        if (studentSATInt != nil) && (studentSATInt <= 1600) && (studentSATInt >= 400) {
        ////
            
            // successfully converted studentSAT to integer
            
            // change many things
            self.setStudentSATLabel()
            self.SATScoreChangeManyThings()
            // fade in comes after we set the studentSATlabel
            self.fadeInGeneral()

            // now we have three situations: the student's score is below the 25th percentile, above the 75th percentile, or in-between
            if studentSATInt < resultViewControllerSelectedUniversity.TwentyFivePercentile {
                // student SAT low
                
                self.resultViewControllerLabel.text = "Your SAT score places you below the 25th percentile of students accepted or matriculated? to \(selectedUniversityName)"
                
            } else if studentSATInt > resultViewControllerSelectedUniversity.SeventyFivePercentile {
                // student SAT high
                
                self.resultViewControllerLabel.text = "Your SAT score places you above the 75th percentile of students accepted or matriculated? to \(selectedUniversityName)"
                
            } else {
                // student SAT in-between
                
                // determine student percentile
                self.determineStudentPercentile()
                self.resultViewControllerLabel.text = "Your SAT score places you on the \(studentSATPercentile!)th percentile of students accepted or matriculated? to \(selectedUniversityName)."
                
            }
            
        ////
        } else {
            // student incorrectly entered information
            self.resultViewControllerLabel.text = "You did not enter an SAT score between 400 and 1600. Please try again and enter an SAT score between 400 and 1600."
        
        ////
        }
    
    ////
    ////
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineStudentPercentile() {
        // we determine student percentile according to the equation (student score - 0th percentile)/(100th percentile - 0th percentile); you have to convert to a float midway through and then unconvert
        
        let studentSATInt:Int? = Int(studentSAT!)
        // we test if the student wrote a correct SAT score
        if (studentSATInt != nil) {
        let studentSATPercentileTopEquation = Float(studentSATInt! - resultViewControllerSelectedUniversity.ZeroPercentile)
        let studentSATPercentileBottomEquation = Float(resultViewControllerSelectedUniversity.HundredPercentile - resultViewControllerSelectedUniversity.ZeroPercentile)
        studentSATPercentile = Int((studentSATPercentileTopEquation/studentSATPercentileBottomEquation)*100)
        }
    }

    func setSATImageViews() {
        
        // these image view constraints must be set AS MULTIPLIERS so that they depend on the university SAT according to the following equation: low SAT view = (low SAT-200)/1600; high SAT view = (1800-SAT)/1600 as MULTIPLIERS; you have to convert to a float midway through
        let lowSATImageViewMultiplier = CGFloat(Float(resultViewControllerSelectedUniversity.TwentyFivePercentile - 200)/Float(1600))
        let highSATImageViewMultiplier = CGFloat(Float(1800 - resultViewControllerSelectedUniversity.SeventyFivePercentile)/Float(1600))
        
        // in order to set university slider and label constraints, must first set left and right image view constraints and then match the university slider and label horizontal constraints so that they are at the edges of the image view constraints
        self.lowSATImageView.translatesAutoresizingMaskIntoConstraints = false
        self.highSATImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let lowSATImageViewWidthConstraint = NSLayoutConstraint(item: lowSATImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.Width, multiplier: lowSATImageViewMultiplier, constant: 0)
        self.resultViewControllerImageView.addConstraint(lowSATImageViewWidthConstraint)
        
        let highSATImageViewWidthConstraint = NSLayoutConstraint(item: highSATImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.Width, multiplier: highSATImageViewMultiplier, constant: 0)
        self.resultViewControllerImageView.addConstraint(highSATImageViewWidthConstraint)
        
    }

    func setUniversitySlider() {
        // add it to the view
        resultViewControllerImageView.addSubview(universitySlider)
        
        // set properties and make slider parts invisible, except for the center
        self.universitySlider.minimumValue = 400
        self.universitySlider.maximumValue = 1600
        self.universitySlider.userInteractionEnabled = false
        self.universitySlider.thumbTintColor = UIColor.clearColor()
        self.universitySlider.minimumTrackTintColor = UIColor.cyanColor()
        self.universitySlider.maximumTrackTintColor = UIColor.cyanColor()
        self.universitySlider.alpha = 0
        
        // set constraints
        self.universitySlider.translatesAutoresizingMaskIntoConstraints = false
        
        // this puts the constraints so that they match the ends of the low and high SAT views (so that the size of the slider is about the same as the size of the university SAT's)
        
        let universitySliderRightMargin = NSLayoutConstraint(item: highSATImageView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: universitySlider, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(universitySliderRightMargin)
        
        let universitySliderLeftMargin = NSLayoutConstraint(item: universitySlider, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: lowSATImageView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(universitySliderLeftMargin)
        
        let universitySliderVerticalConstraint = NSLayoutConstraint(item: universitySlider, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 200)
        self.resultViewControllerImageView.addConstraint(universitySliderVerticalConstraint)
        
    }
    
    func setBackgroundSlider() {
        // add it to the view
        resultViewControllerImageView.addSubview(backgroundSlider)
        
        // set properties and make slider parts invisible, except for the center
        self.backgroundSlider.minimumValue = 400
        self.backgroundSlider.maximumValue = 1600
        self.backgroundSlider.value = 1000
        // this might be needed later for saving data
//        self.backgroundSlider.value = Float(self.studentSAT!)!
        self.backgroundSlider.hidden = true
        self.backgroundSlider.userInteractionEnabled = false
        self.backgroundSlider.minimumTrackTintColor = UIColor.clearColor()
        self.backgroundSlider.maximumTrackTintColor = UIColor.clearColor()
        
        // set constraints
        backgroundSlider.translatesAutoresizingMaskIntoConstraints = false
        
        // this sets the width as a percentage (75%) of the whole view, but expand it to 80% so that it appears that the label is on the center of the scroll
        let backgroundSliderWidthConstraint = NSLayoutConstraint(item: backgroundSlider, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.Width, multiplier: 0.8, constant: 0)
        self.resultViewControllerImageView.addConstraint(backgroundSliderWidthConstraint)
        
    }
    
    func setTwentyFivePercentileLabel() {
        // add it to the view
        resultViewControllerImageView.addSubview(twentyFivePercentileLabel)
        
        // set properties
        self.twentyFivePercentileLabel.text = "400"
        self.twentyFivePercentileLabel.alpha = 0
        
        // set constraints; make it so that the horizontal constraint centers the label on the trailing/right margin of the low SAT view
        self.twentyFivePercentileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let twentyFivePercentileLabelHorizontalConstraint = NSLayoutConstraint(item: twentyFivePercentileLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: lowSATImageView, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(twentyFivePercentileLabelHorizontalConstraint)
        
        let twentyFivePercentileLabelVerticalConstraint = NSLayoutConstraint(item: twentyFivePercentileLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: universitySlider, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 25)
        self.resultViewControllerImageView.addConstraint(twentyFivePercentileLabelVerticalConstraint)
        
    }

    func setSeventyFivePercentileLabel() {
        // add it to the view
        resultViewControllerImageView.addSubview(seventyFivePercentileLabel)
        
        // set properties
        self.seventyFivePercentileLabel.text = "1600"
        self.seventyFivePercentileLabel.alpha = 0
        
        // set constraints; make it so that the horizontal constraint centers the label on the leading/left margin of the high SAT view
        self.seventyFivePercentileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let seventyFivePercentileLabelHorizontalConstraint = NSLayoutConstraint(item: seventyFivePercentileLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: highSATImageView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(seventyFivePercentileLabelHorizontalConstraint)
        
        let seventyFivePercentileLabelVerticalConstraint = NSLayoutConstraint(item: seventyFivePercentileLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: universitySlider, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 25)
        self.resultViewControllerImageView.addConstraint(seventyFivePercentileLabelVerticalConstraint)
        
    }
    
    func setStudentSATLabel() {
        // add it to the view
        resultViewControllerImageView.addSubview(studentSATLabel)
        
        // set properties
        let studentSATInt:Int? = Int(studentSAT!)
        if studentSATInt < 1000 {
            // this is so the scroll appears on the center
            self.studentSATLabel.text = " \(studentSAT!)"
        } else {
            self.studentSATLabel.text = studentSAT!
        }
        self.studentSATLabel.alpha = 0
        
        // set constraints
        self.studentSATLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let studentSATLabelHorizontalConstraint = NSLayoutConstraint(item: studentSATLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: studentSATImageView, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(studentSATLabelHorizontalConstraint)
        
        let studentSATLabelVerticalConstraint = NSLayoutConstraint(item: studentSATLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: universitySlider, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: -30)
        self.resultViewControllerImageView.addConstraint(studentSATLabelVerticalConstraint)
        
    }
    
    func SATScoreChangeManyThings() {
        // put in the slider/label values and unhide background slider
        self.backgroundSlider.hidden = false
        self.twentyFivePercentileLabel.text = String(resultViewControllerSelectedUniversity.TwentyFivePercentile)
        self.seventyFivePercentileLabel.text = String(resultViewControllerSelectedUniversity.SeventyFivePercentile)
        
        let studentSATInt:Int? = Int(studentSAT!)
        if (studentSATInt != nil) && (studentSATInt <= 1600) && (studentSATInt >= 400) {
            
            // change student SAT width so that the left side matches the student SAT score, so we can use this in the future to place the location of the student SAT label
            
            self.studentSATImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let studentSATImageViewMultiplier = CGFloat(Float(1800 - studentSATInt!)/Float(1600))
            
            let studentSATImageViewWidthConstraint = NSLayoutConstraint(item: studentSATImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.Width, multiplier: studentSATImageViewMultiplier, constant: 0)
            self.resultViewControllerImageView.addConstraint(studentSATImageViewWidthConstraint)
            
        }
    }
    
    func fadeInGeneral () {
    ////
    ////
        self.resultViewControllerLabel.alpha = 0
        
        // set animation so that non-student-related items gradually fade in
        UIView.animateWithDuration(1.5, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
        ////
            
            self.resultViewControllerLabel.alpha = 1
            self.twentyFivePercentileLabel.alpha = 1
            self.seventyFivePercentileLabel.alpha = 1
            self.universitySlider.alpha = 1
        }) { (Bool) in
        ////
            
            // after animation is complete, make the thumb of the slider slide into the slider in a non-linear manner
            UIView.animateKeyframesWithDuration(1.5, delay: 0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: {
                
                // in order to do that, we need to know what point of the slider the thumb will hit; this equation solves this through multiplier = (low SAT-200)/1600 * width of the overall image view
                let studentSATFloat:Float? = Float(self.studentSAT!)
                let pathXVariable:CGFloat = CGFloat( ((Float(studentSATFloat!) - 200)/Float(1600)) * Float(self.resultViewControllerImageView.bounds.width) )
                
                // we do some magic with keyframes, which I don't understand
                let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
                let mutablePath = CGPathCreateMutable()
                
                // this is the starting point (we set the x value as -50 behind the view, the y-value is the university slider's y-value)
                CGPathMoveToPoint(mutablePath, nil, -50, self.universitySlider.center.y)
                
                // then we set it to curve; the first two values pathXVariable/2 and 50 are the values which set the curve point, the last two values are the values which the thumb lands on, and pathXVariable is determined by the equationa above, whereas they-value is the university slider's y-value
                CGPathAddQuadCurveToPoint(mutablePath, nil, pathXVariable/2, 50, pathXVariable, self.universitySlider.center.y)
                
                keyFrameAnimation.path = mutablePath
                // actually the timer is this; the arguments don't have any effect
                keyFrameAnimation.duration = 1.5
                keyFrameAnimation.fillMode = kCAFillModeForwards
                keyFrameAnimation.removedOnCompletion = false
                
                // this type of animation needs to add a layer in which the background slider is the object
                self.backgroundSlider.layer.addAnimation(keyFrameAnimation, forKey: "animation")
                }, completion: nil)
            
            // when the image loads, also make the student SAT score fade-in (after the slider thumb lands)
            UIView.animateWithDuration(2, delay: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.studentSATLabel.alpha = 1
                }, completion: nil)
            
        ////
        }
    
    ////
    ////
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
            