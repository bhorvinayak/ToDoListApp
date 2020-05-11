//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Vinayak Bhor on 30/06/19.
//  Copyright © 2019 Vinayak Bhor. All rights reserved.
//
import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    //var categoryArray = [Ca]()
    var categoryArray = [Category]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    // UIApplication.shared.delegate is Singleton object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
       
    override func viewDidLoad() {
        super.viewDidLoad()

        print("dataFilePath : \(dataFilePath)")
        loadCategory()
    }

    // MARK: - Table view data source
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        //value = condition ? valueIfTrue : valueIfFalse
        //cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    

    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todaey Category", message: "", preferredStyle: .alert)
        
        let alertAction =  UIAlertAction(title: "Add New Category", style: .default) {(action) in
            print("Sucess")
            
            print("entered text :\(textField.text!)")
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            print("Item Array \(self.categoryArray)")
            self.saveData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            
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
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        do{
            
            categoryArray = try context.fetch(request)
            
        }catch{
            print("Error While Fetching \(error)")
        }
        
    }
    
}
