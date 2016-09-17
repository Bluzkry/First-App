//
//  DataTableViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 9/14/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit
import CoreData

var savedUniversities:Array? = [UniversityData]()
var savedSAT:Array? = [NSManagedObject]()

class DataTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // LOAD CORE DATA
        // get a managed object context through an application delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // use NSFetchRequest to fetch from core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentInputData")
        
        // hand fetch request over to managed object context
        do {
            let results = try managedContext.fetch(fetchRequest)
            savedSAT = results as? [NSManagedObject]
        } catch let error as NSError {
            print ("Could not fetch \(error), \(error.userInfo)")
        }
        
        // BACKGROUND VIEW
        // add a background view to the table view
        let backgroundImage = UIImage(named: "Background Data")
        let imageView = UIImageView(image:backgroundImage)
        self.tableView.backgroundView = imageView
        
        // no lines where there aren't cells
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // center and scale background image
        imageView.contentMode = .scaleAspectFill
        
        // low alpha
        imageView.alpha = 0.5
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let existingSavedSAT = savedSAT {
            // if the user has saved data, the rows are the count
            return existingSavedSAT.count
        } else {
            // otherwise it's zero
            return 0
        }
    }
    
    // translucent cell backgrounds so we can see the image but still easily read the contents
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    ////
    
        // table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "DataTableViewCell"
        let dataCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DataTableViewCell
        
        // check if the user has saved data
        if let existingSavedSAT = savedSAT {
            
            // fetches the appropriate university and SAT for the table cell
            let savedSingleUniversity = savedUniversities?[(indexPath as NSIndexPath).row]
            let savedSingleSAT = existingSavedSAT[(indexPath as NSIndexPath).row]
            
            // fetches the appropriate university for the data source layout
            dataCell.dataUniversityLabel.text = "\(savedSingleUniversity?.UniversityName)"
            dataCell.dataScoreLabel.text = "Score: \(savedSingleSAT.value(forKey: "savedSATCore") as! String), Percentile: \(savedSingleSAT.value(forKey: "savedPercentileCore") as! String)"
            
            
        }
        
        // Configure the cell...
        return dataCell
    
    ////
    }
    
    // override to support conditional editing of the table view. i.e. deletion
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // override to support editing the table view. i.e. deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            savedUniversities?.remove(at: (indexPath as NSIndexPath).row)
            savedSAT?.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // override to support rearranging the table view, especially the values
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // check if the user has saved data
        if let existingSavedSAT = savedSAT {
            
            // fetches the appropriate university and SAT for the table cell
            let savedSingleUniversity = savedUniversities?[sourceIndexPath.row]
            let savedSingleSAT = existingSavedSAT[sourceIndexPath.row]
            
            // temporarily deletes them from the data
            savedUniversities?.remove(at: sourceIndexPath.row)
            savedSAT?.remove(at: sourceIndexPath.row)
            
            // inserts them at the place where the data is moved
            savedUniversities?.insert(savedSingleUniversity!, at: destinationIndexPath.row)
            savedSAT?.insert(savedSingleSAT, at: destinationIndexPath.row)
            
        }
    }

    // override to support conditional rearranging of the table view
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // return false if you do not want the item to be re-orderable.
        return true
    }
    
//    // override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//
//    // override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
    
    // if user clicks a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user selected a row, the selectedUniversity variable has to be changed to this
        
        if let existingSavedSAT = savedSAT {
            selectedUniversity = savedUniversities?[(indexPath as NSIndexPath).row]
            
            let savedSATIndexRow = existingSavedSAT[(indexPath as NSIndexPath).row]
            
            studentSAT = savedSATIndexRow.value(forKey: "savedSATCore") as! String?
            
            // trigger the segue to go to the next view
            self.performSegue(withIdentifier: "segueFromDataTableViewController", sender: self)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueFromDataTableViewController" {
            // get the new view controller using segue.destinationViewController.
            let destinationResultController = segue.destination as! UINavigationController
            let targetResultController = destinationResultController.topViewController as! ResultViewController
            
            // make the view controller's data variable true
            targetResultController.fromData = true
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
