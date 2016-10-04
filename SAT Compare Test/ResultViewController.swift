	//
//  ResultViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/31/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit
import CoreData

class ResultViewController: UIViewController {

    @IBOutlet weak var textBackground: UIView!
    @IBOutlet var resultViewControllerImageView: UIView!
    @IBOutlet weak var resultViewControllerText: UILabel!
    @IBOutlet weak var lowSATImageView: UIView!
    @IBOutlet weak var highSATImageView: UIView!
    // this image view is at the right and is for the positioning of the student label
    @IBOutlet weak var studentSATImageView: UIView!
    
    @IBOutlet weak var universitySlider: UISlider!
    @IBOutlet weak var sliderBackground: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var backToData: UIBarButtonItem!
    
    var backgroundSlider: UISlider! = UISlider()
    var twentyFivePercentileLabel: UILabel! = UILabel()
    var seventyFivePercentileLabel: UILabel! = UILabel()
    var studentSATLabel: UILabel! = UILabel()

    // MARK
    // MARK PREPARATION FOR LATER PARTS
    // get these numbers for later equations in the result view
    // average
    let MedianPercentile:Int = (selectedUniversity!.topMathPercentile.intValue + selectedUniversity!.topReadingPercentile.intValue + selectedUniversity!.bottomMathPercentile.intValue + selectedUniversity!.bottomReadingPercentile.intValue)/2
    
    let TwentyFivePercentile:Int = selectedUniversity!.bottomReadingPercentile.intValue + selectedUniversity!.bottomMathPercentile.intValue
    
    let SeventyFivePercentile:Int = selectedUniversity!.topReadingPercentile.intValue + selectedUniversity!.topMathPercentile.intValue
    
    // 25th percentile minus difference between 25th percentile and median
    let ZeroPercentile:Int = 2*(selectedUniversity!.bottomReadingPercentile.intValue + selectedUniversity!.bottomMathPercentile.intValue) - (selectedUniversity!.topMathPercentile.intValue + selectedUniversity!.topReadingPercentile.intValue + selectedUniversity!.bottomMathPercentile.intValue + selectedUniversity!.bottomReadingPercentile.intValue)/2
    
    // 75th percentile plus difference between 75th percentile and median
    let HundredPercentile:Int = 2*(selectedUniversity!.topReadingPercentile.intValue + selectedUniversity!.topMathPercentile.intValue) - (selectedUniversity!.topMathPercentile.intValue + selectedUniversity!.topReadingPercentile.intValue + selectedUniversity!.bottomMathPercentile.intValue + selectedUniversity!.bottomReadingPercentile.intValue)/2
    
    // this is needed at top for determining the student SAT percentile
    var studentSATPercentile:Int = 0
    
    // this is for changing things if this comes from the data controller
    var fromData:Bool = false
    
    
    // MARK
    // MARK VIEW LIFE CYCLE
    override func viewDidLoad() {
    ////
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set sliders and labels
        self.setUniversitySlider()
        self.setBackgroundSlider()
        self.setSATImageViews()
        self.setSeventyFivePercentileLabel()
        self.setTwentyFivePercentileLabel()
        self.saveButton.layer.cornerRadius = 4
        
        // change many things
        self.setStudentSATLabel()
        self.SATScoreChangeManyThings()
        
        // fade in comes after we set the studentSATlabel and determine whether or not it comes from the main view or the data
        self.comesFromMainView()
        
        // presentation based on different ACT/SAT, language, score
        self.presentationBasedOnSelectedVariables()
    ////
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK
    // MARK SET UP DATA/CONSTRAINTS FOR THE VIEW (E.G. SLIDERS, LABELS)
    func determineStudentPercentile() {
        // we determine student percentile according to the equation (student score - 0th percentile)/(100th percentile - 0th percentile); you have to convert to a float midway through and then unconvert
        let studentSATInt:Int = Int(studentSAT!)!
        let studentSATPercentileTopEquation = Float(studentSATInt - ZeroPercentile)
        let studentSATPercentileBottomEquation = Float(HundredPercentile - ZeroPercentile)
        studentSATPercentile = Int((studentSATPercentileTopEquation/studentSATPercentileBottomEquation)*100)
    }

    func setSATImageViews() {
        
        // these image view constraints must be set AS MULTIPLIERS so that they depend on the university SAT according to the following equation: low SAT view = (low SAT-200)/1600; high SAT view = (1800-SAT)/1600 as MULTIPLIERS; you have to convert to a float midway through
        let lowSATImageViewMultiplier = CGFloat(Float(TwentyFivePercentile - 200)/Float(1600))
        let highSATImageViewMultiplier = CGFloat(Float(1800 - SeventyFivePercentile)/Float(1600))
        
        // in order to set university slider and label constraints, must first set left and right image view constraints and then match the university slider and label horizontal constraints so that they are at the edges of the image view constraints
        self.lowSATImageView.translatesAutoresizingMaskIntoConstraints = false
        self.highSATImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let lowSATImageViewWidthConstraint = NSLayoutConstraint(item: lowSATImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.width, multiplier: lowSATImageViewMultiplier, constant: 0)
        self.resultViewControllerImageView.addConstraint(lowSATImageViewWidthConstraint)
        
        let highSATImageViewWidthConstraint = NSLayoutConstraint(item: highSATImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.width, multiplier: highSATImageViewMultiplier, constant: 0)
        self.resultViewControllerImageView.addConstraint(highSATImageViewWidthConstraint)
        
    }

    func setUniversitySlider() {
        // add it to the view
        resultViewControllerImageView.addSubview(universitySlider)
        
        // set properties and make slider parts invisible, except for the center
        self.universitySlider.thumbTintColor = UIColor.clear
        self.universitySlider.layer.cornerRadius = 8
        self.universitySlider.alpha = 0
        self.sliderBackground.layer.cornerRadius = 6
        self.sliderBackground.alpha = 0
        
        // set images for slider
        // this will actually be quite difficult; you have to customize the size of the insets according to the slider size
        
        // set constraints
        self.universitySlider.translatesAutoresizingMaskIntoConstraints = false
        
        // this puts the constraints so that they match the ends of the low and high SAT views (so that the size of the slider is about the same as the size of the university SAT's)
        let universitySliderRightMargin = NSLayoutConstraint(item: highSATImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: universitySlider, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(universitySliderRightMargin)
        
        let universitySliderLeftMargin = NSLayoutConstraint(item: universitySlider, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: lowSATImageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(universitySliderLeftMargin)
        
    }
    
    func setBackgroundSlider() {
        // add it to the view
        resultViewControllerImageView.addSubview(backgroundSlider)
        
        // set properties and make slider parts invisible, except for the center
        self.backgroundSlider.minimumValue = 400
        self.backgroundSlider.maximumValue = 1600
        self.backgroundSlider.value = 1000
        self.backgroundSlider.isUserInteractionEnabled = false
        self.backgroundSlider.minimumTrackTintColor = UIColor.clear
        self.backgroundSlider.maximumTrackTintColor = UIColor.clear
        
        // set image
        let thumbImage = UIImage(named: "SAT Score")
        self.backgroundSlider.setThumbImage(thumbImage, for: UIControlState())
        self.backgroundSlider.layer.cornerRadius = 4
        
        // set constraints
        backgroundSlider.translatesAutoresizingMaskIntoConstraints = false
        
        // this sets the width as a percentage (75%) of the whole view, but expand it to 80% so that it appears that the label is on the center of the scroll
        let backgroundSliderWidthConstraint = NSLayoutConstraint(item: backgroundSlider, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.width, multiplier: 0.8, constant: 0)
        self.resultViewControllerImageView.addConstraint(backgroundSliderWidthConstraint)
        
    }
    
    func setTwentyFivePercentileLabel() {
        // add it to the view
        resultViewControllerImageView.addSubview(twentyFivePercentileLabel)
        
        // set properties
        self.twentyFivePercentileLabel.text = "400"
        self.twentyFivePercentileLabel.alpha = 0
        self.twentyFivePercentileLabel.font = twentyFivePercentileLabel.font.withSize(12)
        
        // set constraints; make it so that the horizontal constraint centers the label on the trailing/right margin of the low SAT view
        self.twentyFivePercentileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // if the SAT scores overlap, set a constraint so that the 25% label is always to the left of the 75% label
        if SeventyFivePercentile-TwentyFivePercentile <= 130 {
            let twentyFivePercentileRightConstraint = NSLayoutConstraint(item: seventyFivePercentileLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: twentyFivePercentileLabel, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 5)
            self.resultViewControllerImageView.addConstraint(twentyFivePercentileRightConstraint)
        } else {
            let twentyFivePercentileLabelHorizontalConstraint = NSLayoutConstraint(item: twentyFivePercentileLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: lowSATImageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            self.resultViewControllerImageView.addConstraint(twentyFivePercentileLabelHorizontalConstraint)
        }
        
        let twentyFivePercentileLabelVerticalConstraint = NSLayoutConstraint(item: twentyFivePercentileLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: universitySlider, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 25)
        self.resultViewControllerImageView.addConstraint(twentyFivePercentileLabelVerticalConstraint)
        
    }

    func setSeventyFivePercentileLabel() {
        // add it to the view
        resultViewControllerImageView.addSubview(seventyFivePercentileLabel)
        
        // set properties
        self.seventyFivePercentileLabel.text = "1600"
        self.seventyFivePercentileLabel.alpha = 0
        self.seventyFivePercentileLabel.font = seventyFivePercentileLabel.font.withSize(12)
        
        // set constraints; make it so that the horizontal constraint centers the label on the leading/left margin of the high SAT view
        self.seventyFivePercentileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let seventyFivePercentileLabelHorizontalConstraint = NSLayoutConstraint(item: seventyFivePercentileLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: highSATImageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(seventyFivePercentileLabelHorizontalConstraint)
        
        let seventyFivePercentileLabelVerticalConstraint = NSLayoutConstraint(item: seventyFivePercentileLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: universitySlider, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 25)
        self.resultViewControllerImageView.addConstraint(seventyFivePercentileLabelVerticalConstraint)
        
    }
    
    func setStudentSATLabel() {
        // add it to the view
        resultViewControllerImageView.addSubview(studentSATLabel)
        self.studentSATLabel.font = studentSATLabel.font.withSize(12)
        
        // set properties
        let studentSATInt:Int = Int(studentSAT!)!
        if studentSATInt < 1000 {
        // this is so the scroll appears on the center
            self.studentSATLabel.text = " \(studentSAT!)"
        } else {
            self.studentSATLabel.text = "\(studentSAT!)"
        }
        self.studentSATLabel.alpha = 0
        
        // set constraints
        self.studentSATLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let studentSATLabelHorizontalConstraint = NSLayoutConstraint(item: studentSATLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: studentSATImageView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        self.resultViewControllerImageView.addConstraint(studentSATLabelHorizontalConstraint)
        
        let studentSATLabelVerticalConstraint = NSLayoutConstraint(item: studentSATLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: universitySlider, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: -25)
        self.resultViewControllerImageView.addConstraint(studentSATLabelVerticalConstraint)
        
    }
    
    // MARK
    // MARK CHANGE THINGS DEPENDING ON ACT/SAT, LANGUAGE, SCORE
    func presentationBasedOnSelectedVariables() {
    ////
    ////
        // six situations
        let studentSATInt:Int = Int(studentSAT!)!
        let selectedUniversityName = selectedUniversity!.universityName
        let 选择大学 = selectedUniversity!.chineseName
        determineStudentPercentile()
        
        if 中文==false && studentSATInt<TwentyFivePercentile {
            // 1: English, below the 25th percentile
            
            self.titleLabel.text = "\(selectedUniversityName)"
            self.resultViewControllerText.text = "Your SAT score places you below the 25th percentile of students enrolled at \(selectedUniversityName)."
            self.doneButton.title = "Done"
            self.backToData.title = "Back"
            self.saveButton.setTitle("Save", for: UIControlState.normal)
    ////
        } else if 中文==false && studentSATInt>=TwentyFivePercentile && studentSATInt<=SeventyFivePercentile {
            // 2: English, middle percentile
            
            self.titleLabel.text = "\(selectedUniversityName)"
            self.resultViewControllerText.text = "Your SAT score places you on the \(studentSATPercentile)th percentile of students enrolled at \(selectedUniversityName)."
            self.doneButton.title = "Done"
            self.backToData.title = "Back"
            self.saveButton.setTitle("Save", for: UIControlState.normal)
    ////
        } else if 中文==false && studentSATInt>SeventyFivePercentile {
            // 3: English, above the 75th percentile
            
            self.titleLabel.text = "\(selectedUniversityName)"
            self.resultViewControllerText.text = "Your SAT score places you above the 75th percentile of students enrolled at \(selectedUniversityName)."
            self.doneButton.title = "Done"
            self.backToData.title = "Back"
            self.saveButton.setTitle("Save", for: UIControlState.normal)
    ////
        } else if 中文==true && studentSATInt<TwentyFivePercentile {
            // 4: 中文, below the 25th percentile
            
            self.titleLabel.text = "\(选择大学)"
            self.resultViewControllerText.text = "你的SAT分数把你排在\(选择大学)最低25%的新生范围。"
            self.doneButton.title = "完成"
            self.backToData.title = "返回"
            self.saveButton.setTitle("存在", for: UIControlState.normal)
    ////
        } else if 中文==true && studentSATInt>=TwentyFivePercentile && studentSATInt<=SeventyFivePercentile {
            // 5: 中文, middle percentile
            
            self.titleLabel.text = "\(选择大学)"
            self.resultViewControllerText.text = "你的SAT分数把你排在\(选择大学)\(studentSATPercentile)%的新生范围。"
            self.doneButton.title = "完成"
            self.backToData.title = "返回"
            self.saveButton.setTitle("存在", for: UIControlState.normal)
    ////
        } else if 中文==true && studentSATInt>SeventyFivePercentile {
            // 6: 中文, above the 75th percentile
            
            self.titleLabel.text = "\(选择大学)"
            self.resultViewControllerText.text = "你的SAT分数把你排在\(选择大学)最高75%的新生范围。"
            self.doneButton.title = "完成"
            self.backToData.title = "返回"
            self.saveButton.setTitle("存在", for: UIControlState.normal)
        }
    ////
    ////
    }
    
    // MARK
    // MARK ANIMATIONS
    func SATScoreChangeManyThings() {
        // put in the slider/label values and unhide background slider
        self.backgroundSlider.isHidden = false
        self.twentyFivePercentileLabel.text = String(TwentyFivePercentile)
        self.seventyFivePercentileLabel.text = String(SeventyFivePercentile)
            
        // change student SAT width so that the left side matches the student SAT score, so we can use this in the future to place the location of the student SAT label
        self.studentSATImageView.translatesAutoresizingMaskIntoConstraints = false
            
        let studentSATInt:Int = Int(studentSAT!)!
        
        let studentSATImageViewMultiplier = CGFloat(Float(1800 - studentSATInt)/Float(1600))
            
        let studentSATImageViewWidthConstraint = NSLayoutConstraint(item: studentSATImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.width, multiplier: studentSATImageViewMultiplier, constant: 0)
        self.resultViewControllerImageView.addConstraint(studentSATImageViewWidthConstraint)

    }
    
    func comesFromMainView() {
        if fromData == false {
            fadeInGeneral()

            // make the back button invisible and unusable
            backToData.tintColor = UIColor.clear
            backToData.isEnabled = false
        } else {
            // if it's from the data table, we don't do any animations and just set everything to unhidden
            self.textBackground.alpha = 1
            self.resultViewControllerText.alpha = 1
            self.twentyFivePercentileLabel.alpha = 1
            self.seventyFivePercentileLabel.alpha = 1
            self.universitySlider.alpha = 1
            self.sliderBackground.alpha = 1
            self.studentSATLabel.alpha = 1
            // we also hide and disable the button
            saveButton.isHidden = true
            saveButton.isEnabled = false
            // set the background slider value to the student SAT
            // set background slider constraints (same height the same as the university slider, center width, value equal to the student SAT)
            self.backgroundSlider.translatesAutoresizingMaskIntoConstraints = false
            
            let backgroundSliderHorizontalConstraint = NSLayoutConstraint(item: backgroundSlider, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: universitySlider, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
            self.resultViewControllerImageView.addConstraint(backgroundSliderHorizontalConstraint)
            
            let backgroundSliderVerticalConstraint = NSLayoutConstraint(item: backgroundSlider, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: resultViewControllerImageView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
            self.resultViewControllerImageView.addConstraint(backgroundSliderVerticalConstraint)
            
            self.backgroundSlider.value = Float(studentSAT!)!
            
        }
    }
    
    func fadeInGeneral() {
    ////
    ////
            
        // set animation so that non-student-related items gradually fade in
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
        ////
            self.textBackground.alpha = 1
            self.resultViewControllerText.alpha = 1
            self.twentyFivePercentileLabel.alpha = 1
            self.seventyFivePercentileLabel.alpha = 1
            self.sliderBackground.alpha = 1
            self.universitySlider.alpha = 1
            
        }) { (Bool) in
        ////
            
            // after animation is complete, make the thumb of the slider slide into the slider in a non-linear manner
            UIView.animateKeyframes(withDuration: 1, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {
                
                // in order to do that, we need to know what point of the slider the thumb will hit; this equation solves this through multiplier = (low SAT-200)/1600 * width of the overall image view
                let studentSATInt:Int = Int(studentSAT!)!
                let studentSATFloat:Float? = Float(studentSATInt)
                let pathXVariable:CGFloat = CGFloat( ((Float(studentSATFloat!) - 200)/Float(1600)) * Float(self.resultViewControllerImageView.bounds.width) )
                
                // we do some magic with keyframes, which I don't understand
                let keyFrameAnimation = CAKeyframeAnimation(keyPath: "position")
                let mutablePath = CGMutablePath()
                
                // this is the starting point (we set the x value as -50 behind the view, the y-value is the university slider's y-value)
                mutablePath.move(to: CGPoint.init(x: -50, y: self.universitySlider.center.y))
//                    CGPathMoveToPoint(mutablePath, nil, -50, self.universitySlider.center.y)
                
                // then we set it to curve; the first two values pathXVariable/2 and 50 are the values which set the curve point, the last two values are the values which the thumb lands on, and pathXVariable is determined by the equationa above, whereas they-value is the university slider's y-value
                mutablePath.addQuadCurve(to: CGPoint.init(x: pathXVariable, y: self.universitySlider.center.y), control: CGPoint.init(x: pathXVariable, y: 50))
//                    CGPathAddQuadCurveToPoint(mutablePath, nil, pathXVariable/2, 50, pathXVariable, self.universitySlider.center.y)
                
                keyFrameAnimation.path = mutablePath
                // actually the timer is this; the arguments don't have any effect
                keyFrameAnimation.duration = 1
                keyFrameAnimation.fillMode = kCAFillModeForwards
                keyFrameAnimation.isRemovedOnCompletion = false
                
                // this type of animation needs to add a layer in which the background slider is the object
                self.backgroundSlider.layer.add(keyFrameAnimation, forKey: "animation")
                }, completion: nil)
            
            // when the image loads, also make the student SAT score fade-in (after the slider thumb lands)
            UIView.animate(withDuration: 1, delay: 1, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.studentSATLabel.alpha = 1
                }, completion: nil)
            
        ////
        }

    ////
    ////
    }
    
    // MARK
    // MARK SAVE DATA AND PREPARE FOR SEGUES
    @IBAction func saveUniversity(_ sender: AnyObject) {
    ////
//        let 中文SavedAlertController = UIAlertController(title: "通知：", message: "你的大学以保存。", preferredStyle: UIAlertControllerStyle.alert) 确定
//        中文SavedAlertController.addAction(<#T##UIAlertAction#>)
        
        // create an alert to tell students if data is missing
        let savedAlertController = UIAlertController(title: alertControllerTitle(), message: alertControllerMessage(), preferredStyle: UIAlertControllerStyle.alert)
        savedAlertController.addAction(UIAlertAction(title: alertControllerAction(), style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            // after dismissing the alert, we save the data as core data
            // note that the percentile differs based on the three factors below
            let studentSATInt:Int = Int(studentSAT!)!
            if studentSATInt < self.TwentyFivePercentile {
                self.saveCoreData(dataSAT: studentSAT!, dataPercentile: "<25%", dataUniversity: selectedUniversity!)
            } else if studentSATInt > self.SeventyFivePercentile {
                self.saveCoreData(dataSAT: studentSAT!, dataPercentile: ">75%", dataUniversity: selectedUniversity!)
            } else {
                self.saveCoreData(dataSAT: studentSAT!, dataPercentile: "\(self.studentSATPercentile)%", dataUniversity: selectedUniversity!)
            }
        })
        )
        
        // present
        self.present(savedAlertController, animated: true, completion: nil)
    
    ////
    }
    
    // we need to change alert controller text based on language
    func alertControllerTitle() -> String {
        switch 中文 {
        case false:
            return "Notice:"
        case true:
            return "通知："
        }
    }
    
    func alertControllerMessage() -> String {
        switch 中文 {
        case false:
            return "Your university has been saved."
        case true:
            return "你的大学已保存。"
        }
    }
    
    func alertControllerAction() -> String {
        switch 中文 {
        case false:
            return "Dismiss"
        case true:
            return "确定"
        }
    }

    // to persist data, we need to save as core data
    func saveCoreData(dataSAT:String, dataPercentile: String, dataUniversity: UniversityData) {
    ////
    ////
        // we get a reference to the app delegate and use that to retrieve the AppDelegate's NSManagedObjectContext, which is like a memory "scratchpad" we need for CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
    ////
        // create a new managed object (savedDataObject) and insert into the managed object context
        let studentInputDataEntity = NSEntityDescription.entity(forEntityName: "StudentInputData", in: managedContext)
        let studentInputDataObject = NSManagedObject(entity: studentInputDataEntity!, insertInto: managedContext)
    ////
        let studentUniversityDataEntity = NSEntityDescription.entity(forEntityName: "UniversityData", in: managedContext)
        let newSavedUniversity = UniversityData(entity: studentUniversityDataEntity!, insertInto: managedContext)
    ////
        // set SAT and percentile attributes using key-value coding
        studentInputDataObject.setValue(dataSAT, forKey: "savedSATCore")
        studentInputDataObject.setValue(dataPercentile, forKey: "savedPercentileCore")
        studentInputDataObject.setValue((Date.timeIntervalSinceReferenceDate*1000), forKey: "savedDate")
        
        newSavedUniversity.universityName = (dataUniversity.universityName)
        newSavedUniversity.chineseName = (dataUniversity.chineseName)
        newSavedUniversity.bottomReadingPercentile = (dataUniversity.bottomReadingPercentile)
        newSavedUniversity.bottomMathPercentile = (dataUniversity.bottomMathPercentile)
        newSavedUniversity.topReadingPercentile = (dataUniversity.topReadingPercentile)
        newSavedUniversity.topMathPercentile = (dataUniversity.topMathPercentile)
        newSavedUniversity.studentData = true
        newSavedUniversity.savedDate = NSNumber(value:Float(Date.timeIntervalSinceReferenceDate)*1000)
    ////
        // commit changes to the saved data object and save to disk
        do {
            try managedContext.save()
            
            // now the managed object is in the core data persistent store, but we still have to handle the possible
        } catch let error as NSError {
            print("could not save \(error), \(error.userInfo)")
        }
    ////
    ////
    }
    
    // segues back to the data view if we hit the back button
    @IBAction func backToData(_ sender: AnyObject) {
        performSegue(withIdentifier: "segueBackToData", sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    ////
        if segue.identifier == "segueSearchDone" {
            // we reset the global variables when we're done
            studentSAT = nil
            selectedUniversity = nil
        }
        
        if segue.identifier == "segueBackToData" {
            // if we come from the data and return to the data, we have to go to the tab view and set the tab as the data tab (not the main view)
            let tabVC = segue.destination as! UITabBarController
            tabVC.selectedIndex = 1
            studentSAT = nil
            selectedUniversity = nil
        }
    ////
    }

}
            
