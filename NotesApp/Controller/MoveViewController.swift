//
//  MoveViewController.swift
//  NotesApp
//
//  Created by Evneet kaur on 2020-01-28.
//  Copyright © 2020 Evneet kaur. All rights reserved.
//

import UIKit

class MoveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

   var notesDelegate: NotesTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryModel.categoryData.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        cell.textLabel?.text = CategoryModel.categoryData[indexPath.row].title
        return cell
       }
       
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func cancel(_ sender: UIButton) {
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Move to \(CategoryModel.categoryData[indexPath.row].title)", message: "Are you sure?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction  = UIAlertAction(title: "Move", style: .default) { (action) in
            self.notesDelegate?.moveNotes(index: indexPath.row)
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    
    }
    

}
