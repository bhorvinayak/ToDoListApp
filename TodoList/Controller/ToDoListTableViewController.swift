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
    var selectedCategory : Category?{
              didSet{
                  loadData()
              }
          }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        loadData(with: request)
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

        doList[indexPath.row].done = !doList[indexPath.row].done
        saveData()
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
                 newItem.parentCategory = self.selectedCategory
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
    
    //MARK:- Read Operation
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
           request.predicate = categoryPredicate
        }
        
        do{
            doList = try context.fetch(request)
            
        }catch{
            
            print("Error in While Fetching \(error)")
        }
        tableView.reloadData()
    }
    

}

extension ToDoListTableViewController : UISearchBarDelegate{
    
    // MARK: - Searchbar delegate method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadData(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    // MARK: - For back to the original list
        if searchBar.text?.count == 0{
            loadData()
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
