//
//  InfoViewController.swift
// SAT Compare
//
//  Created by Alexander Zou on 9/10/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!
    
    let appExplanationImageView = UIImageView(image: UIImage(named: "Explanation Image"))
    
    // get userdefaults for language
    @IBOutlet weak var 中文TextView: UITextView!
    let appUserDefaults = UserDefaults.standard
    @IBOutlet weak var englishTextView: UITextView!
    var 中文:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set language
        中文 = appUserDefaults.bool(forKey: "language")
        
        // do not let text be editable
        self.englishTextView.isEditable = false
        self.中文TextView.isEditable = false
        
        switch 中文! {
        case false:
            self.backBarButtonItem.title = "Back"
            self.中文TextView.alpha = 0
        case true:
            self.backBarButtonItem.title = "返回"
            self.englishTextView.alpha = 0
        }
        
        // add picture of pyramid to the text in order to explain to readers what the App does
        addExplanationImage()

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
    
    func addExplanationImage() {
        // in order to find the location of the text, we create an NSString which we set as the attributed text.string of our textview
        let searchableText = 中文TextView.attributedText.string as NSString
        // then we find the place to input the text by using the range method of NSString
        let searchRange = searchableText.range(of: "http://opa.berkeley.edu/sites/default/files/uc_berkeley_cds_2015-16_8-3-2016.pdf", options: [], range: NSMakeRange(0, searchableText.length))
        中文TextView.layoutManager.ensureLayout(for: 中文TextView.textContainer)

        // the image attachment is an NSTextAttachment
        // then we add an image to this NSTextAttachment
        // then we create an NSAttributedString and attach this NSTextAttachment to the NSAttributedString
        let explanationImageAttachment = NSTextAttachment()
        explanationImageAttachment.image = appExplanationImageView.image
        let explanationImage = NSAttributedString(attachment: explanationImageAttachment)
        
        // in order for the image to be centered, we have to add a NSMutableParagraphStyle object to the final string; here we make the style as an object
        let explanationStyle = NSMutableParagraphStyle()
        explanationStyle.alignment = NSTextAlignment.center
        
        // another problem is that we need to add a return key after the image, so we need to find a way to concatenate both the image and the return key; we do this by creating another NSAttributedString
        // we then created an NSMutableAttributedString and append both NSAttributedStrings to it (the image and the return key)
        let explanationReturn = NSAttributedString(string: "\n\n\n")
        
        let explanationMutable = NSMutableAttributedString(string: "\n")
        explanationMutable.append(explanationImage)
        explanationMutable.append(explanationReturn)
        
        // now we want the image to be centered, so we add the NSMutableParagraphStyle to the NSMutableAttributedString (this has to be done after adding the picture)
        // for the length, it's an NSMakeRange object from 0 to the length of the mutable string
        explanationMutable.addAttributes([NSParagraphStyleAttributeName: explanationStyle], range: NSMakeRange(0, explanationMutable.length))
        
        // finally we insert the mutable attributed string into the textview
        中文TextView.textStorage.insert(explanationMutable, at: searchRange.location)
        
        // overall NSTextAttachment => NSAttributedString #1
        // NSAttributedString #1 + NSAttributedString #2 => NSMutableAttributedString
        // NSMutableParagraphStyle => NSMutableAttributedString
        // NSMutableAttributedString => UITextView (textStorage)
    }

}
