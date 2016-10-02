//
//  DataTableViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 9/14/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit
import CoreData

//var savedUniversities:Array? = [UniversityData]()
//var savedSAT:Array? = [NSManagedObject]()

class DataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var studentSATFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var universityFetchedResultsController: NSFetchedResultsController<UniversityData>!
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK
    // MARK VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // fetch results
        self.initializeFetchedResultsController()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        // LOAD CORE DATA
//        // get a managed object context through an application delegate
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let managedContext = appDelegate.persistentContainer.viewContext
//        
//        // use NSFetchRequest to fetch from core data
//        let studentSATFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentInputData")
//        studentSATFetchRequest.returnsObjectsAsFaults = false
//        
//        let studentUniversityFetchRequest = NSFetchRequest<UniversityData>(entityName: "UniversityData")
//        studentUniversityFetchRequest.returnsObjectsAsFaults = false
//        
//        // use NSPredicate to search and filter university data so that it only includes universities saved by the student (because the database contains all the universities, not just those saved by the student)
//        studentUniversityFetchRequest.predicate = NSPredicate(format: "studentData = true")
//        
//        // hand fetch request over to managed object context
//        do {
//            let studentSATResults = try managedContext.fetch(studentSATFetchRequest)
//            savedSAT = studentSATResults as? [NSManagedObject]
//            
//            let studentUniversityResults = try managedContext.fetch(studentUniversityFetchRequest)
////            savedUniversities = try managedContext.fetch(studentUniversityFetchRequest)
//            print(savedUniversities)
//            savedUniversities = studentUniversityResults as? [UniversityData]
//            print(savedUniversities)
////            for i in 0...(studentUnivSersityResults.count-1) {
////                testVariable = studentUniversityResult as UniversityDataß
////            }
//            
//            print(savedUniversities)
//        } catch let error as NSError {
//            print ("Could not fetch \(error), \(error.userInfo)")
//        }
        
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
    
    func initializeFetchedResultsController() {
        ////
        
        // get a managed object context through an application delegate
        
        // use nsfetchrequest to fetch from core data
        let studentSATFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentInputData")
        studentSATFetchRequest.returnsObjectsAsFaults = false
        
        let studentUniversityFetchRequest = NSFetchRequest<UniversityData>(entityName: "UniversityData")
        studentUniversityFetchRequest.returnsObjectsAsFaults = false
        
        // use nspredicate and nssortdescriptor to search and filter university data so that it only includes universities saved by the student (because the database contains all the universities, not just those saved by the student)
        // note that nssortdescriptor is required to use nsfetchedresultscontroller
        let SATSortDescriptor = NSSortDescriptor(key: "savedDate", ascending: true)
        studentSATFetchRequest.sortDescriptors = [SATSortDescriptor]
        
        let universitySortDescriptor = NSSortDescriptor(key: "savedDate", ascending: true)
        studentUniversityFetchRequest.sortDescriptors = [universitySortDescriptor]
        studentUniversityFetchRequest.predicate = NSPredicate(format: "studentData = true")
        
        // initialize fetched results controllers and hand fetch request over to managed object context
        studentSATFetchedResultsController = NSFetchedResultsController(fetchRequest: studentSATFetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        universityFetchedResultsController = NSFetchedResultsController(fetchRequest: studentUniversityFetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // conjure fetched results controllers and set delegates
        self.studentSATFetchedResultsController.delegate = self
        self.universityFetchedResultsController.delegate = self
        
        // perform fetch
        do {
            try studentSATFetchedResultsController.performFetch()
//            let studentSATResults = try studentSATFetchedResultsController.performFetch()
//            savedSAT = studentSATResults as? [NSManagedObject]
        } catch {
            fatalError("Failed to initialize studentFetchedResultsController: \(error)")
        }
        
        do {
            try universityFetchedResultsController.performFetch()
//            let studentUniversityResults = try universityFetchedResultsController.performFetch()
//            savedUniversities = studentUniversityResults as? [UniversityData]
        } catch {
            fatalError("Failed to initialize universityFetchedResultsController: \(error)")
        }
        
        ////
    }
    
    // MARK
    // MARK TABLE VIEW CONFIGURATION
    func configureCell(_ dataCell: DataTableViewCell, indexPath: NSIndexPath) {
        let studentSATSelectedObject = studentSATFetchedResultsController.object(at: indexPath as IndexPath) as? NSManagedObject
        let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
        
        if let singleSATScore = studentSATSelectedObject?.value(forKey: "savedSATCore") as? String {
            let singlePercentileScore = studentSATSelectedObject?.value(forKey: "savedPercentileCore") as? String
            let singleUniversity = universitySelectedObject.value(forKey: "universityName")
            
            dataCell.dataUniversityLabel.text = "\(singleUniversity!)"
            dataCell.dataScoreLabel.text = "Score: \(singleSATScore), Percentile: \(singlePercentileScore!)"
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ////
        
        // table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "DataTableViewCell"
        let dataCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DataTableViewCell
        
        configureCell(dataCell, indexPath: indexPath as NSIndexPath)
        
//        // check if the user has saved data
//        if let existingSavedSAT = savedSAT {
//            
//            // fetches the appropriate university and SAT for the table cell
//            let savedSingleUniversity = savedUniversities?[(indexPath as NSIndexPath).row]
//            let savedSingleSAT = existingSavedSAT[(indexPath as NSIndexPath).row]
//            
//            // fetches the appropriate university for the data source layout
//            dataCell.dataUniversityLabel.text = "\(savedSingleUniversity!.universityName)"
//            dataCell.dataScoreLabel.text = "Score: \(savedSingleSAT.value(forKey: "savedSATCore") as! String), Percentile: \(savedSingleSAT.value(forKey: "savedPercentileCore") as! String)"
//        
//            
////        }
        
        // Configure the cell...
        return dataCell
        
        ////
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = studentSATFetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
//        if let existingSavedUniversities = savedUniversities {
//            // if the user has saved data, the rows are the count
//            return existingSavedUniversities.count
        } else {
            // otherwise it's zero
            return 0
        }
    }
    
    // translucent cell backgrounds so we can see the image but still easily read the contents
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
    }
    
    
    // MARK
    // MARK FETCHED RESULTS CONTROLLER DELEGATE METHODS
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!) as! DataTableViewCell
            configureCell(cell, indexPath: indexPath! as NSIndexPath)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK
    // MARK TABLE VIEW DATA CHANGES
    // override to support conditional editing of the table view. i.e. deletion
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // override to support editing the table view. i.e. deletion
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            savedUniversities?.remove(at: (indexPath as NSIndexPath).row)
//            savedSAT?.remove(at: (indexPath as NSIndexPath).row)
            let studentSATSelectedObject = studentSATFetchedResultsController.object(at: indexPath as IndexPath) as? NSManagedObject
            let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
            managedContext.delete(studentSATSelectedObject!)
            managedContext.delete(universitySelectedObject)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

//    // override to support rearranging the table view, especially the values
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        // check if the user has saved data
//        if let existingSavedSAT = savedSAT {
//            
//            // fetches the appropriate university and SAT for the table cell
//            let savedSingleUniversity = savedUniversities?[sourceIndexPath.row]
//            let savedSingleSAT = existingSavedSAT[sourceIndexPath.row]
//            
//            // temporarily deletes them from the data
//            savedUniversities?.remove(at: sourceIndexPath.row)
//            savedSAT?.remove(at: sourceIndexPath.row)
//            
//            // inserts them at the place where the data is moved
//            savedUniversities?.insert(savedSingleUniversity!, at: destinationIndexPath.row)
//            savedSAT?.insert(savedSingleSAT, at: destinationIndexPath.row)
//            
//        }
//    }

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
    
    
    // MARK
    // MARK SEGUE FUNCTIONS
    // if user clicks a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user selected a row, the selectedUniversity variable has to be changed to this
        
        let studentSATSelectedObject = studentSATFetchedResultsController.object(at: indexPath as IndexPath) as? NSManagedObject
        let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
        
        if let singleSATScore = studentSATSelectedObject?.value(forKey: "savedSATCore") as? String {
            
            selectedUniversity = universitySelectedObject
            studentSAT = singleSATScore
            
//        if let existingSavedSAT = savedSAT {
//            selectedUniversity = savedUniversities?[(indexPath as NSIndexPath).row]
//            
//            let savedSATIndexRow = existingSavedSAT[(indexPath as NSIndexPath).row]
//            
//            studentSAT = savedSATIndexRow.value(forKey: "savedSATCore") as! String?
        
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
