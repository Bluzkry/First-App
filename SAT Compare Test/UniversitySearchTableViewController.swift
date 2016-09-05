//
//  UniversitySearchTableViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 8/21/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit

class UniversitySearchTableViewController: UITableViewController, UISearchResultsUpdating {

    let model:UniversityModel = UniversityModel()
    var totalData:[UniversityData] = [UniversityData]()
    
    // this indicates the search result
    var filteredUniversities = [UniversityData]()
    var universitySearchViewControllerSelectedUniversity: UniversityData?

    // we need to set up these foundations for the search
    var universitySearchController: UISearchController!
    var universityResultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get data from the data model
        self.totalData = self.model.getData()
        
        // set up the search controller
        self.universitySearchController = UISearchController(searchResultsController: self.universityResultsController)
        self.tableView.tableHeaderView = self.universitySearchController.searchBar
        self.universitySearchController.searchResultsUpdater = self
        self.universityResultsController.tableView.dataSource = self
        self.universityResultsController.tableView.delegate = self
        self.universitySearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    ////
        
        // filter through the universities
        self.filteredUniversities = self.totalData.filter({ (data:UniversityData) -> Bool in
            return data.UniversityName.lowercaseString.containsString(self.universitySearchController.searchBar.text!.lowercaseString)
            // 以后需要加中文 return data.中文名字.containsString(self.universitySearchController.searchBar.text!)
        })
        
        // update the results table view
        self.universityResultsController.tableView.reloadData()
        
        /* OPTION 2: let totalDataUniversityString = String(totalData)
        
        // filter through the universities
        self.filteredUniversities = self.totalData.filter({ (data:UniversityData) -> Bool in
            if totalDataUniversityString.lowercaseString.containsString(self.universitySearchController.searchBar.text!.lowercaseString) == true {
                return true
            } else {
                return false
            }
        }) */
        
        /* self.filteredUniversities = self.totalData.filter { (data:UniversityData) -> Bool in
            if totalData.lowercaseString.containsString(self.universitySearchController.searchBar.text!.lowercaseString) {
                return true
            } else {
                return false
            } */
        
    ////
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // number of sections is 1
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // this gives the number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if universitySearchController.active && universitySearchController.searchBar.text != "" {
            // if we search, the rows is the number of rows in our filtered universities
            return self.filteredUniversities.count
        } else {
            // otherwise it's 0
            return 0
        }
    }
    
    // what's in the table (kinda confused on this one)
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let data:UniversityData
        
        if universitySearchController.active && universitySearchController.searchBar.text != "" {
            // if we search, what's in the table is the filtered universities
            data = filteredUniversities[indexPath.row]
        } else {
            // otherwise it's nothing
            data = UniversityData()
        }
        
        cell.textLabel!.text = data.UniversityName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // user selected a row, the selectedUniversity variable has to be changed to this
        universitySearchViewControllerSelectedUniversity = filteredUniversities[indexPath.row]
        
        // trigger the segue to go to the next view
        self.performSegueWithIdentifier("segueToNavigationControllerTwo", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueToNavigationControllerTwo"{
            
            // get the new view controller using segue.destinationViewController.
            let DestinationNavigationViewControllerTwo = segue.destinationViewController as! UINavigationController
            let targetBetweenViewController = DestinationNavigationViewControllerTwo.topViewController as! BetweenViewController
            
            // Pass the selected university object to the new view controller
            targetBetweenViewController.betweenViewControllerSelectedUniversity = universitySearchViewControllerSelectedUniversity
        }
        
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // this is where you have to put any changes before the next view appears
 
    }*/
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
