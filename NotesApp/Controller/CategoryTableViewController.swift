//
//  CategoryTableViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var currentIndx = -1
    var count = 1
    var dataSaved = false
    var contextEnity : NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        contextEnity = context
        
        
//        cleardata()
//        clearCategoryEntity()
//        
//
        load()
//
        NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CategoryModel.categoryData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        let name = CategoryModel.categoryData[indexPath.row].title
        cell?.textLabel?.text = name
        cell?.detailTextLabel?.text = "notes: \(CategoryModel.categoryData[indexPath.row].notes.count)"

        // Configure the cell...

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, sucess) in
           
            
            
            let name = CategoryModel.categoryData[indexPath.row].title
             let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
            request.predicate = NSPredicate(format: "categoryName contains %@", name)
            request.returnsObjectsAsFaults = false
            do{
                let results = try self.contextEnity?.fetch(request)
                for result in results as! [NSManagedObject]{
                    self.contextEnity?.delete(result)
                }
            }catch{
                print(error)
            }
            do{
                try self.contextEnity?.save()
            }catch{
                print(error)
            }
             CategoryModel.categoryData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
      
        if let destination = segue.destination as? NotesTableViewController{
            destination.categoryDelegate = self
            
            if let tableviewCell = sender as? UITableViewCell{
                if let index = tableView.indexPath(for: tableviewCell)?.row{
                    currentIndx = index
                    destination.notesCurrentIndx = index
                    
                }
            }
        }
        
    }
    
    func reload(){
        tableView.reloadData()
    }
    
    
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alert.addTextField { (text) in
            text.placeholder = "category"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let name = alert.textFields?.first?.text
            
            if name == ""{
                
                let alertc = UIAlertController(title: "Empty", message: nil, preferredStyle: .alert)
                let okA = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertc.addAction(okA)
                self.present(alertc, animated: true, completion: nil)
                
            }else{
                let entityCat = NSEntityDescription.insertNewObject(forEntityName: "CategoryEntity", into: self.contextEnity!)
                           entityCat.setValue(name, forKey: "categoryName")
                           let c = CategoryModel(title: name!, notes: [])
                           CategoryModel.categoryData.append(c)
                           self.tableView.reloadData()
            }
           
        }
        alert.addAction(cancel)
        alert.addAction(addAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func saveCoreData(){
        
        cleardata()
        
        for note in CategoryModel.categoryData {
//             let entity = NSEntityDescription.insertNewObject(forEntityName: "NotesEntity", into: contextEnity!)
            
//            entity.setValue(note.title, forKey: "categoryName")
            for detailnote in note.notes {
//                let urlString : String?
                let entity = NSEntityDescription.insertNewObject(forEntityName: "NotesEntity", into: contextEnity!)
                
                entity.setValue(note.title, forKey: "noteCategory")
                entity.setValue(detailnote.title, forKey: "notesTitle")
                entity.setValue(detailnote.desc, forKey: "notesDesc")
                entity.setValue(detailnote.date, forKey: "date")
                entity.setValue(detailnote.latitude, forKey: "lat")
                entity.setValue(detailnote.longitude, forKey: "long")
                
                if detailnote.image != nil{
                    let imagedata = detailnote.image?.pngData()
                    entity.setValue(imagedata, forKey: "image")
                }
                
                if detailnote.recordedUrl != nil{
                    print("when saved  \(detailnote.recordedUrl)")
                   let  urlString = "\(detailnote.recordedUrl!)"
                    entity.setValue(urlString, forKey: "recordedUrl")
                }
                
                if detailnote.editeddate != nil{
                    entity.setValue(detailnote.editeddate, forKey: "editedDate")
                }
                
                
            }
        }
        do{
            try contextEnity?.save()
        }catch{
            print(error)
        }
    }
    
    func load(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        do{
            var fetchednotes = [Note]()
            let result = try contextEnity?.fetch(request)
            if result is [NSManagedObject]{
                for resultitem in result as! [NSManagedObject]{
                    let cname = resultitem.value(forKey: "categoryName") as! String
                    
                    let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
                    fetchrequest.predicate = NSPredicate(format: "noteCategory contains %@", cname)
                    fetchrequest.returnsObjectsAsFaults = false
                    
                    do{
                        let fetchresult = try contextEnity?.fetch(fetchrequest)
                        if fetchresult is [NSManagedObject]{
                            for result  in fetchresult as! [NSManagedObject]{
                                var n : Note
//                                var nurl : URL?
//                                let rname = result.value(forKey: "noteCategory") as! String
                                let nName = result.value(forKey: "notesTitle") as! String
                                let ndesc = result.value(forKey: "notesDesc") as! String
                                let ndate = result.value(forKey: "date") as! Date
                                let nlat = result.value(forKey: "lat") as! Double
                                let nlong = result.value(forKey: "long") as! Double
                                
                                if result.value(forKey: "image") != nil && result.value(forKey: "recordedUrl") == nil{
                                    
                                    let data = result.value(forKey: "image") as? Data
                                    let nimage = UIImage(data: data!)
                                    
                                    if result.value(forKey: "editedDate") != nil{
                                        let edate = result.value(forKey: "editedDate") as! Date
                                        
                                        n = Note(title: nName, desc: ndesc, latitude: nlat, longitude: nlong, date: ndate, image: nimage!, editdate: edate)
                                }else{
                                    n = Note(title: nName, desc: ndesc, latitude: nlat, longitude: nlong, date: ndate, image: nimage!)
                                }
                            }
                                    
                
                               else if result.value(forKey: "recordedUrl") != nil && result.value(forKey: "image") == nil{
                                    
                                    
                                    let urlstring = result.value(forKey: "recordedUrl") as? String
                                      let nurl = URL(fileURLWithPath: urlstring ?? "")
                                    print("only record file  \(urlstring!)")
                                    
                                    if result.value(forKey: "editedDate") != nil{
                                        let edate = result.value(forKey: "editedDate") as! Date
                                        n = Note(title: nName, desc: ndesc, latitude: nlat, longitude: nlong, date: ndate, record: nurl, editdate: edate)
                                    }else{
                                    
                                    n = Note(title: nName, desc: ndesc, latitude: nlat, longitude: nlong, date: ndate, record: nurl)
                                   }
                                }
                                else if result.value(forKey: "recordedUrl") == nil && result.value(forKey: "image") == nil{
                                    if result.value(forKey: "editedDate") != nil{
                                        let edate = result.value(forKey: "editedDate") as! Date
                                        n = Note(title: nName, desc: ndesc, latitude: nlat, longitude: nlong, date: ndate, editdate: edate)
                                    }
                                    else{
                                        n = Note(title: nName, desc: ndesc, latitude: nlat, longitude: nlong, date: ndate)
                                    }
                                }
                                
                                
                                else{
                                    let data = result.value(forKey: "image") as? Data
                                    let nimage = UIImage(data: data!)
                                    let urlstring = result.value(forKey: "recordedUrl") as? String
                                
                                     let nurl = URL(fileURLWithPath: urlstring ?? "")
                                    print("both image and url  \(urlstring)")
                                    
                                    if result.value(forKey: "editedDate") != nil{
                                        let edate = result.value(forKey: "editedDate") as! Date
                                        n = Note(title: nName, desc: ndesc, image: nimage!, latitude: nlat, longitude: nlong, date: ndate, recordedUrl: nurl, editdate: edate)
                                    }else{
                                    
                                    n = Note(title: nName, desc: ndesc, image: nimage!, latitude: nlat, longitude: nlong, date: ndate, recordedUrl: nurl as URL)
                                }
                                }
                                
                                
//                                let n = Note(title: nName, desc: ndesc, image: nimage!, latitude: nlat, longitude: nlong, date: ndate)
                                fetchednotes.append(n)
//                                fetchednotes.append(n)
                            }
                        }
                        
                    }catch{
                        print(error)
                    }
                    
                   
                    
//                    CategoryModel.categoryData.append(CategoryModel(title: cname, notes: []))
                    
//                    print(resultitem.value(forKey: "categoryName") as! String)
//                    print(resultitem.value(forKey: "notesTitle") as! String)
//                    print(resultitem.value(forKey: "notesDesc") as! String)
//                    print("\(resultitem.value(forKey: "date") as! Date)")
//                    print("\(resultitem.value(forKey: "lat") as! Double)")
//                    print("\(resultitem.value(forKey: "long") as! Double)")
                    CategoryModel.categoryData.append(CategoryModel(title: cname, notes: fetchednotes))
                    fetchednotes = []
                    
                }
            }
        }catch{
            print(error)
        }
        do{
            try contextEnity?.save()
        }catch{
            print(error)
        }
    }
    
    func cleardata() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NotesEntity")
        do{
            let result = try contextEnity?.fetch(request)
            if result is [NSManagedObject]{
                for resultitem in result as! [NSManagedObject]{
                    contextEnity?.delete(resultitem)
                }
            }
        }catch{
            print(error)
        }
        do{
            try contextEnity?.save()
        }catch{
            print(error)
        }
    }
    
    func clearCategoryEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CategoryEntity")
        do{
            let result = try contextEnity?.fetch(request)
            if result  is [NSManagedObject]{
                for item in result as! [NSManagedObject] {
                    contextEnity?.delete(item)
                }
            }
        }catch{
            print(error)
        }
    }
    
    
    
    
}
