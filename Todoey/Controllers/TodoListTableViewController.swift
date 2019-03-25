//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Barnes on 3/1/19.
//  Copyright © 2019 Eric Barnes. All rights reserved.
//

import UIKit
import CoreData

class TodoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    let cellID = "TodoListItemCell"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // get appDelegate as object and grab ref to context of persistent container
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

    // MARK: - Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    // MARK: - Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey item", message: nil, preferredStyle: .alert)
        var textField = UITextField()

        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let newItem = Item(context: self.context) // create new item that will exists in the specified context (staging area)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory

            self.itemArray.append(newItem)
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            // code ran when textField is created
            alertTextField.placeholder = "Add new item"
            textField = alertTextField

        }

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving context: \(error)")
        }
        tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate { // if additional predicate is passed as parameter
            request.predicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        
        tableView.reloadData()
    }

}

extension TodoListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request: NSFetchRequest<Item> = Item.fetchRequest() // Create fetch request with Item entity from core data

        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItems(with: request, predicate: predicate)
    } // end of func

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         if searchBar.text?.count == 0 { // once we click the cancel and send the erase all of the text
            loadItems() // reload all items

            DispatchQueue.main.async { // use main thread for UI updates
                searchBar.resignFirstResponder()  // dismiss keyboard / relinquish control from searchBar
            }
        }
    } // end of func

}

