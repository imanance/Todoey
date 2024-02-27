//
//  ViewController.swift
//  Todoey
//
//  Created by Iman on 2024-02-19.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let colorHex = selectedCategory?.color else { fatalError() }
        
        title = selectedCategory?.name
        
        updateNavBar(backHex: colorHex, foreColor: .white)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(backHex: "ffffff", foreColor: .systemBlue)
        
    }
    
    //MARK: - NavBar setup methods
    func updateNavBar(
        backHex backgroundHexCode: String,
        foreColor: UIColor
    ) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        navBar.barTintColor = UIColor(hex: backgroundHexCode)
        navBar.tintColor = foreColor
        
        let whiteForegroundColor = [
            NSAttributedString.Key.foregroundColor : foreColor
        ]
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = whiteForegroundColor
        navBarAppearance.largeTitleTextAttributes = whiteForegroundColor
        
        navBarAppearance.backgroundColor = UIColor(hex: backgroundHexCode)
        navBar.compactAppearance = navBarAppearance // before: noColor, after: noColor
        navBar.standardAppearance = navBarAppearance // before: noColor, after: color
        navBar.scrollEdgeAppearance = navBarAppearance  // before: color, after: noColor
            
        searchBar.barTintColor = UIColor(hex: backgroundHexCode)
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row \(indexPath.row)")
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        cell.backgroundColor = generateColor(
            for: UIColor(hex: selectedCategory!.color),
            with: CGFloat(indexPath.row) / CGFloat(todoItems!.count)
        )
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let cat = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        cat.items.append(newItem)
                    }
                    
                } catch {
                    print("Error saving new Item, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manupulation Methods
   
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
            
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
            // no need to reload using destructive for expansionStyle in Swipe Cell options
//            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?
            .filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
