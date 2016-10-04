//
//  DataTableViewController.swift
//  SAT Compare Test
//
//  Created by Alexander Zou on 9/14/16.
//  Copyright © 2016 Alexander Zou. All rights reserved.
//

import UIKit
import CoreData

class DataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var studentSATFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var universityFetchedResultsController: NSFetchedResultsController<UniversityData>!
    // necessary for changing table rows
    var changingRows:Bool = false
    // get managedcontextobject through the application delegate
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
        // use nsfetchrequest to fetch from core data
        let studentSATFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StudentInputData")
        studentSATFetchRequest.returnsObjectsAsFaults = false
        
        let studentUniversityFetchRequest = NSFetchRequest<UniversityData>(entityName: "UniversityData")
        studentUniversityFetchRequest.returnsObjectsAsFaults = false
        
        // use nspredicate and nssortdescriptor to search and filter university data so that it only includes universities saved by the student (because the database contains all the universities, not just those saved by the student)
        // note that nssortdescriptor is required to use nsfetchedresultscontroller
        let SATSortDescriptorDate = NSSortDescriptor(key: "savedDate", ascending: true)
        studentSATFetchRequest.sortDescriptors = [SATSortDescriptorDate]
        
        let universitySortDescriptorDate = NSSortDescriptor(key: "savedDate", ascending: true)
        studentUniversityFetchRequest.sortDescriptors = [universitySortDescriptorDate]
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
        } catch {
            fatalError("Failed to initialize studentFetchedResultsController: \(error)")
        }
        
        do {
            try universityFetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize universityFetchedResultsController: \(error)")
        }
    ////
    }
    
    // MARK
    // MARK TABLE VIEW CONFIGURATION
    // this function is necessary to configure the table view cell and is coded according to the Apple documentation
    func configureCell(_ dataCell: DataTableViewCell, indexPath: NSIndexPath) {
    ////
    ////
        let studentSATSelectedObject = studentSATFetchedResultsController.object(at: indexPath as IndexPath) as? NSManagedObject
        let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
        
        if let singleSATScore = studentSATSelectedObject?.value(forKey: "savedSATCore") as? String {
        ////
            let singlePercentileScore = studentSATSelectedObject?.value(forKey: "savedPercentileCore") as? String
            let singleUniversity = universitySelectedObject.value(forKey: "universityName")
            let 大学 = universitySelectedObject.value(forKey: "chineseName")
            
            switch 中文 {
            case false:
                dataCell.dataUniversityLabel.text = "\(singleUniversity!)"
                dataCell.dataScoreLabel.text = "Score: \(singleSATScore), Percentile: \(singlePercentileScore!)"
            case true:
                dataCell.dataUniversityLabel.text = "\(大学!)"
                dataCell.dataScoreLabel.text = "SAT分数: \(singleSATScore), 百分位: \(singlePercentileScore!)"
            } // case ended
        ////
        } // if let statement ended
    ////
    ////
    }
    
        // we configure the cell, but most of it is based on the configureCell function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // table view cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "DataTableViewCell"	
        let dataCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DataTableViewCell
        
        // Configure the cell...
        configureCell(dataCell, indexPath: indexPath as NSIndexPath)
        return dataCell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        guard let sections = studentSATFetchedResultsController.sections else {
//        return 0
//        }
//        return sections.count
        return 1
    }
    
    // number of rows based on the sat fetchedresultscontroller count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = studentSATFetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    // translucent cell backgrounds so we can see the image but still easily read the contents
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
    }
    
    
    // MARK
    // MARK FETCHED RESULTS CONTROLLER DELEGATE METHODS according to the Apple documentation
    // note that we do not call these methods if we are changing table rows
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if changingRows == false {
            tableView.beginUpdates()
        } else {
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if changingRows == false {
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
        } else {
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if changingRows == false {
            tableView.endUpdates()
        } else {
            return
        }
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
            let studentSATSelectedObject = studentSATFetchedResultsController.object(at: indexPath as IndexPath) as? NSManagedObject
            let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
            managedContext.delete(studentSATSelectedObject!)
            managedContext.delete(universitySelectedObject)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("could not save \(error), \(error.userInfo)")
            }

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            // note editing style will never be insert
        }    
    }
    
    // deletion option in editing style doesn't appear
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // no indentation in editing style
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // override to support rearranging the table view, especially the values
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    ////
        // bypass the delegate methods temporarily
        self.changingRows = true
        
        // we have to refresh the core data
        self.initializeFetchedResultsController()
    ////
        // get objects at index path; note that we have to do a lot of complicated casting (student data to nsnumber then int64 then back, university to int64 then back)
        let studentSATSelectedObject = studentSATFetchedResultsController.object(at: sourceIndexPath as IndexPath) as? NSManagedObject
        let universitySelectedObject = universityFetchedResultsController.object(at: sourceIndexPath as IndexPath)
        
        let studentSATDestinationObject = studentSATFetchedResultsController.object(at: destinationIndexPath as IndexPath) as? NSManagedObject
        let universityDestinationObject = universityFetchedResultsController.object(at: destinationIndexPath)
        let studentSATDestinationObjectSavedDate:NSNumber = studentSATDestinationObject?.value(forKeyPath: "savedDate")! as! NSNumber
        let universityDestinationObjectSavedDate:Int64 = universityDestinationObject.savedDate.int64Value
    ////
        // if the row we're moving is above the target row, we add one to the date so that the source row ends up below the target row
        if sourceIndexPath.row < destinationIndexPath.row {
        // we add 1 to the destination index object's savedate
        let studentSATSelectedObjectChangedDate = NSNumber(value:(studentSATDestinationObjectSavedDate.int64Value + 1))
        studentSATSelectedObject?.setValue(studentSATSelectedObjectChangedDate, forKey: "savedDate")
        universitySelectedObject.savedDate = NSNumber(value:(universityDestinationObjectSavedDate + 1))
        // otherwise we do the opposite
        } else if sourceIndexPath.row > destinationIndexPath.row {
            let studentSATSelectedObjectChangedDate = NSNumber(value:(studentSATDestinationObjectSavedDate.int64Value - 1))
            studentSATSelectedObject?.setValue(studentSATSelectedObjectChangedDate, forKey: "savedDate")
            universitySelectedObject.savedDate = NSNumber(value:(universityDestinationObjectSavedDate - 1))
        } else {
            return
        }
    ////
        // save
        do {
            try managedContext.save()
        } catch {
            print ("could not save \(error), \(error.localizedDescription)")
        }
    ////
        // then we restart
        self.initializeFetchedResultsController()
        
        // reset delegates
        self.changingRows = true
    ////
    }

    // override to support conditional rearranging of the table view
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // return false if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK
    // MARK SEGUE FUNCTIONS
    // if user clicks a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // user selected a row, the selectedUniversity and studentSAT variable has to be changed to this
        let studentSATSelectedObject = studentSATFetchedResultsController.object(at: indexPath as IndexPath) as? NSManagedObject
        let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
        
        if let singleSATScore = studentSATSelectedObject?.value(forKey: "savedSATCore") as? String {
            selectedUniversity = universitySelectedObject
            studentSAT = singleSATScore
            
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
