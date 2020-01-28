//
//  NotesTableViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-22.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController,UISearchResultsUpdating {
    
    var categoryDelegate : CategoryTableViewController?
    var cellSelected = false
    var notesCurrentIndx = -1
    var notesSelectedIndex = -1
    var filterData : [Note] = []
    var selectedrows : [IndexPath]?
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchController.searchResultsUpdater = self
        
          searchController.obscuresBackgroundDuringPresentation = false
         
          searchController.searchBar.placeholder = "products"
         
          navigationItem.searchController = searchController
         
          definesPresentationContext = true
        
        tableView.allowsMultipleSelection = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       if searchController.isActive{
                return filterData.count
            }else{
            return CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell")
                let n : Note
                if searchController.isActive{
                    n = filterData[indexPath.row]
                }
                
                else{
                    n = CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes[indexPath.row]
                }
                
        //        let noteTitle = CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes[indexPath.row].title
                
                cell?.textLabel?.text = n.title

                // Configure the cell...

                return cell!
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let delAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
               CategoryModel.categoryData[self.categoryDelegate!.currentIndx].notes.remove(at: indexPath.row)
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
           return UISwipeActionsConfiguration(actions: [delAction])
       }
    
    func updateSearchResults(for searchController: UISearchController) {
           let searchBar = searchController.searchBar
           filteproducts(searchBar.text!)
       }
       
       override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
       }
       override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           tableView.cellForRow(at: indexPath)?.accessoryType = .detailButton
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
       if let destination = segue.destination as? ViewController{
                    destination.notesDelegate = self
                    if let tablecell = sender as? UITableViewCell{
                        if let index = tableView.indexPath(for: tablecell)?.row{
        //                    let note1 = CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes[index]
                            self.cellSelected = true
                            self.notesSelectedIndex = index
                            destination.objectSelected = true
        //                    destination.noteDetail = note1
                            destination.viewIndex = index
                            
                            let n : Note
                            if searchController.isActive{
                                n = filterData[index]
                                destination.noteDetail = n
                            }
                            
                            else{
                                n = CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes[index]
                                destination.noteDetail = n
                            }
                            
                            
                        }
                    }

                }
                
                if let move = segue.destination as? MoveViewController{
                    move.notesDelegate = self
                }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        categoryDelegate?.reload()
    }
    
    func notesReload(){
        tableView.reloadData()
    }
    
    func filteproducts(_ searchText : String){
    //        filterData = Products.productsData.filter({ (product: Products) -> Bool in
    //            return product.name.lowercased().contains(searchText.lowercased())
    //        })
    //        tableView.reloadData()
            
            filterData = CategoryModel.categoryData[categoryDelegate!.currentIndx].notes.filter({ (category: Note) -> Bool in
                return category.title.lowercased().contains(searchText.lowercased())
            })
            
            tableView.reloadData()

        }
    
    
        func moveNotes(index :Int){
            selectedrows = tableView.indexPathsForSelectedRows!
            for i in selectedrows!{
                let movenote = CategoryModel.categoryData[categoryDelegate!.currentIndx].notes[i.row]
                CategoryModel.categoryData[index].notes.append(movenote)
            }
            for n in selectedrows!{
                CategoryModel.categoryData[categoryDelegate!.currentIndx].notes.remove(at: n.row)
                tableView.deleteRows(at: [n], with: .fade)
            }
        }
        
    
    
//    func updateNotes(note : Note){
//        
//        
//       
//        
////        let notes :[Note] = []
//        let note1 = CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes
//
//        guard !note1.isEmpty && notesCurrentIndx != -1 else {
//            CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes.append(note)
//            tableView.reloadData()
//            categoryDelegate?.reload()
//            return
//        }
//
//
//
//        CategoryModel.categoryData[(categoryDelegate?.currentIndx)!].notes[notesCurrentIndx] = note
//        let indexpath = IndexPath(item: notesCurrentIndx, section: 0)
//        tableView.reloadRows(at: [indexpath], with: .middle)
//        notesCurrentIndx = -1
//
//        
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        categoryDelegate?.saveCoredata()
//    }
//    func updateText(text : String){
//
//
//
//               guard FolderStructure.folderData[(folderDelegate?.curIndx)!].notes != [] && currentIndex != -1 else {
//                   FolderStructure.folderData[(folderDelegate?.curIndx)!].notes.append(text)
//                   tableView.reloadData()
//                   folderDelegate?.reload()
//                   return
//               }
//
//
//               FolderStructure.folderData[(folderDelegate?.curIndx)!].notes[currentIndex] = text
//
//               let indexPath = IndexPath(item: currentIndex, section: 0)
//               tableView.reloadRows(at: [indexPath], with: .middle)
//               currentIndex = -1
//
//         }

}
