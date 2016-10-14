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
    
    var universityFetchedResultsController: NSFetchedResultsController<UniversityData>!
    // get managedcontextobject through the application delegate
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // get nsuserdefaults for language
    let appUserDefaults = UserDefaults.standard
    var 中文:Bool?
    
    // MARK
    // MARK VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // set language
        中文 = appUserDefaults.bool(forKey: "language")
        
        // this is necessary so that when we click a university and then go back, the "main" tab bar's language is still the language that the user has selected
        for i in 0...Int((self.tabBarController?.viewControllers?.count)! - 1) {
            let viewController = self.tabBarController?.viewControllers?[i]
            if i == 0 && 中文 == false {
                viewController?.tabBarItem.title = "Main"
            } else if i == 0 && 中文 == true {
                viewController?.tabBarItem.title = "首页"
            } else if i == 1 && 中文 == false {
                viewController?.tabBarItem.title = "Saved Universities"
            } else if i == 1 && 中文 == true {
                viewController?.tabBarItem.title = "选择大学"
            }
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // fetch results
        self.initializeFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    ////
        super.viewWillAppear(animated)
    ////
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
    ////
        // change language of edit button (apparently this needs to be here for the "edit" button method to be called)
        switch 中文! {
        case false:
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        case true:
            self.navigationItem.rightBarButtonItem?.title = "编辑"
        }
        
        self.tableView.reloadData()
    ////
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeFetchedResultsController() {
    ////
        // use nsfetchrequest to fetch from core data
        let studentUniversityFetchRequest = NSFetchRequest<UniversityData>(entityName: "UniversityData")
        studentUniversityFetchRequest.returnsObjectsAsFaults = false
    ////
        // use nspredicate and nssortdescriptor to search and filter university data so that it only includes universities saved by the student (because the database contains all the universities, not just those saved by the student)
        // note that nssortdescriptor is required to use nsfetchedresultscontroller
        let universitySortDescriptorOrder = NSSortDescriptor(key: "order", ascending: false)
        studentUniversityFetchRequest.sortDescriptors = [universitySortDescriptorOrder]
        studentUniversityFetchRequest.predicate = NSPredicate(format: "studentData = true")
    ////
        // initialize fetched results controllers and hand fetch request over to managed object context
        universityFetchedResultsController = NSFetchedResultsController(fetchRequest: studentUniversityFetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
    ////
        // conjure fetched results controllers and set delegates
        self.universityFetchedResultsController.delegate = self
    ////
        // perform fetch
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
        if let universitySelectedObject = universityFetchedResultsController?.object(at: indexPath as IndexPath) {
            
            let singleSATScore = universitySelectedObject.savedStudentSAT
            let singlePercentileScore = universitySelectedObject.savedStudentPercentile
            let singleUniversity = universitySelectedObject.universityName
            let 大学 = universitySelectedObject.chineseName
            
            switch 中文! {
            case false:
                dataCell.dataUniversityLabel.text = "\(singleUniversity)"
                dataCell.dataScoreLabel.text = "Score: \(singleSATScore), Percentile: \(singlePercentileScore)"
            case true:
                if universitySelectedObject.savedStudentPercentile == "Above 75%" {
                    dataCell.dataUniversityLabel.text = "\(大学)"
                    dataCell.dataScoreLabel.text = "SAT分数: \(singleSATScore) 前25%"
                } else if universitySelectedObject.savedStudentPercentile == "Below 25%" {
                    dataCell.dataUniversityLabel.text = "\(大学)"
                    dataCell.dataScoreLabel.text = "SAT分数: \(singleSATScore) 后25%"
                } else {
                    dataCell.dataUniversityLabel.text = "\(大学)"
                    dataCell.dataScoreLabel.text = "SAT分数: \(singleSATScore) 前\(singlePercentileScore)"
                }
            } // case ended
            
        } // if let statement ended
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
        guard let sections = universityFetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    // number of rows based on the sat fetchedresultscontroller count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = universityFetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    // translucent cell backgrounds so we can see the image but still easily read the contents
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.75)
    }
    
    // change language of "Edit" button
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if self.isEditing && 中文==true {
            self.editButtonItem.title = "完成"
        } else if self.isEditing==false && 中文==true {
            self.editButtonItem.title = "编辑"
        } else if self.isEditing && 中文==false {
            self.editButtonItem.title = "Done"
        } else if self.isEditing==false && 中文==false {
            self.editButtonItem.title = "Edit"
        }
    }
    
    // MARK
    // MARK FETCHED RESULTS CONTROLLER DELEGATE METHODS according to the Apple documentation
    // note that we do not call these methods if we are changing table rows
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if callNSFetchedResultsControllerDelegates == true {
            tableView.beginUpdates()
        } else {
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard callNSFetchedResultsControllerDelegates == true else {
            return
        }
        
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
    
    // this gets rid of some strange errors that happen when i save core data
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        return
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if callNSFetchedResultsControllerDelegates == true {
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
            // we find the university row that we want to delete by selecting the row, then we delete it using the delegate methods (and save the updated data)
            let universitySelectedObject = universityFetchedResultsController.object(at: indexPath as IndexPath)
            managedContext.delete(universitySelectedObject)
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
        callNSFetchedResultsControllerDelegates = false
    ////
        if var totalSavedUniversities = self.universityFetchedResultsController.fetchedObjects {
            // we remove the source university row and insert it in the destination row (while temporarily saving the source university as a property)
            let sourceRowUniversity = totalSavedUniversities[sourceIndexPath.row] as UniversityData
            totalSavedUniversities.remove(at: sourceIndexPath.row)
            totalSavedUniversities.insert(sourceRowUniversity, at: destinationIndexPath.row)
            
            // then we reset the order of all the universities through a for loop
            var index:Int16 = Int16(totalSavedUniversities.count)
            for university in totalSavedUniversities as [UniversityData] {
                index -= 1
                university.order = index
            }
        }
    ////
        // save
        do {
            try managedContext.save()
        } catch {
            print ("could not save \(error), \(error.localizedDescription)")
        }
    ////
        // since the internal state of the table view is in disarray until the method returns, we don't reload our rows until the operation is ended (this moves the operation to the back of the main queue)
        DispatchQueue.main.async { () -> Void in
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: UITableViewRowAnimation.fade)
        }
        
        // reset delegates
        callNSFetchedResultsControllerDelegates = true
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
        if let universitySelectedObject = universityFetchedResultsController?.object(at: indexPath as IndexPath) {
        
            selectedUniversity = universitySelectedObject
            studentSAT = universitySelectedObject.savedStudentSAT
            
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

}
