//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Iman on 2024-02-22.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var catergories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))

        loadCategories()
        
//        tableView.separatorStyle = .none
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catergories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
            cell.textLabel?.text = catergories?[indexPath.row].name ?? "No Categories Added Yet!"
            
        cell.backgroundColor = UIColor(hex: catergories?[indexPath.row].color ?? "3998FF")
        return cell

    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if catergories?[indexPath.row] != nil {
         
            performSegue(withIdentifier: "goToItems", sender: self)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catergories?[indexPath.row]
            
        }
    }
   
    //MARK: - Add New Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            
            let newCat = Category()
            newCat.name = textField.text!
            newCat.color = self.generateRandomColor().toHex() ?? "3998FF"
            
            self.save(category: newCat)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {

        catergories = realm.objects(Category.self)

        tableView.reloadData()
            
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.catergories?[indexPath.row] {

            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }

//            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

    }

}

