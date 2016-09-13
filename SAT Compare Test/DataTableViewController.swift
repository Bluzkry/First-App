//
//  DataTableViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 9/14/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

var savedUniversities:Array? = [UniversityData]()
var savedSAT:Array? = [String]()
var savedPercentile:Array? = [String]()

class DataTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let existingSavedUniversities = savedUniversities {
            // if the user has saved data, the rows are the count
            return existingSavedUniversities.count
        } else {
            // otherwise it's one
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // table view cells are reused and should be dequered using a cell identifier
        let cellIdentifier = "DataTableViewCell"
        let dataCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DataTableViewCell
        
        // check if the user has saved data
        if let existingSavedUniversities = savedUniversities {
            
            // fetches the appropriate university and SAT for the table cell
            let savedSingleUniversity = existingSavedUniversities[indexPath.row]
            let savedSingleSAT = savedSAT![indexPath.row]
            let savedSinglePercentile = savedPercentile![indexPath.row]
            
            // fetches the appropriate university for the data source layout
            dataCell.dataLabel.text = "\(savedSingleUniversity.UniversityName) \nScore: \(savedSingleSAT), Percentile: \(savedSinglePercentile)"
            
        } else {
            // otherwise we say there's no saved data
            dataCell.dataLabel.textAlignment = NSTextAlignment.Center
            dataCell.dataLabel.font = dataCell.dataLabel.font.fontWithSize(24)
            dataCell.dataLabel.text = "You have no saved university."
        }
        
        // Configure the cell...
        return dataCell
    }
    
    // override to support conditional editing of the table view. i.e. deletion
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // override to support editing the table view. i.e. deletion
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            savedUniversities?.removeAtIndex(indexPath.row)
            savedSAT?.removeAtIndex(indexPath.row)
            savedPercentile?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // if user clicks a row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // user selected a row, the selectedUniversity variable has to be changed to this
        if let existingSavedUniversities = savedUniversities {
            selectedUniversity = existingSavedUniversities[indexPath.row]
            studentSAT = savedSAT![indexPath.row]
            // trigger the segue to go to the next view
            self.performSegueWithIdentifier("segueFromDataTableViewController", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueFromDataTableViewController" {
            // get the new view controller using segue.destinationViewController.
//            let destinationResultController = segue.destinationViewController as! UINavigationController
//            let targetResultController = destinationResultController.topViewController as! ResultViewController
//                
//            // make the view controller's data variable true
//            targetResultController.fromData = true
            
            // get the new view controller using segue.destinationViewController.
            let destinationResultController = segue.destinationViewController as! ResultViewController
            
            // make the view controller's data variable true
            destinationResultController.fromData = true
        }
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
