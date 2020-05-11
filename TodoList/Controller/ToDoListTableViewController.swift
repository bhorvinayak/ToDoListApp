//
//  ToDoListTableViewController.swift
//  TodoList
//
//  Created by Vishal Nikam on 11/05/20.
//  Copyright © 2020 Vinayak Bhor. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {

    var doList = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return doList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        // Configure the cell...
        
         let item = doList[indexPath.row]
         cell.textLabel?.text = item.title
         //value = condition ? valueIfTrue : valueIfFalse
         cell.accessoryType = item.done ? .checkmark : .none
         return cell
        
    }
    // MARK: - Table view delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(doList[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
           }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
             let alert = UIAlertController(title: "Add New Todaey Item", message: "", preferredStyle: .alert)
             
             let alertAction =  UIAlertAction(title: "Add New Item", style: .default) {(action) in
                 print("Sucess")
                 
                 print("entered text :\(textField.text!)")
                 let newItem = Item(context: self.context)
                 newItem.title = textField.text!
                 newItem.done = false
                 //newItem.parentCategory = self.selectedCategory
                 self.doList.append(newItem)
                 
                 print("Item Array \(self.doList)")
                 self.saveData()
                 
             }
             
             alert.addTextField { (alertTextField) in
                 
                 alertTextField.placeholder = "Create New Folder"
                 
                 textField = alertTextField
                 
             }
             
             alert.addAction(alertAction)
             
             present(alert, animated: true, completion: nil)
    }
    
    //MARK:- Create Operation
    func saveData(){
        
        do{
            try context.save()
            
        }catch{
            
            print("Error in While Saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    

}
