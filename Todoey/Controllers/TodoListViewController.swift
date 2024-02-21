//
//  ViewController.swift
//  Todoey
//
//  Created by Iman on 2024-02-19.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()

    // ## using UserDefaults
//    let defaults = UserDefaults.standard
    
    // ## using NSCoder - Codable
    let dataFilePath = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appending(path: "Items.plist", directoryHint: .notDirectory)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // code snipet to handle navigationBar color like old versions
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .systemBlue
//        let navBar = navigationController?.navigationBar
//        navBar?.standardAppearance = appearance;
//        navBar?.scrollEdgeAppearance = navBar?.standardAppearance
        
        loadItems()
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        print("cell for row \(indexPath.row)")
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems() {
        // ## using UserDefaults
//            defaults.set(self.itemArray, forKey: "TodoListArray")
        
        
        // ## using NSCoder - Codable
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
//            self.tableView.reloadRows(at: [IndexPath(index: self.itemArray.count - 1)], with: .none)
        tableView.reloadData()
    }
    
    func loadItems() {
        // ## using UserDefaults
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        
        // ## using NSCoder - Codable
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
            
    }
    
}

