//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eric Barnes on 3/24/19.
//  Copyright © 2019 Eric Barnes. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cellID = "categoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
        //
    }
    // MARK: - Date Manipulation Methods

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        // create popup for user to enter new category
        let alert = UIAlertController(title: "New Todoey Category", message: nil, preferredStyle: .alert)
        var textField = UITextField()

        let action = UIAlertAction(title: "Add", style: .default) { (action) in

            let newCategory = Category(context: self.context) // create new Category instance linked to context
            newCategory.name = textField.text! // configure category using textfield

            self.categories.append(newCategory) // add new category to array of categories
            self.saveCategories() // save new category in context to db
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "enter new category"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    func saveCategories() {
        do {
            try context.save() // saves whatever is currently loaded into the context into the db
        } catch {
            print("error saving category: \(error)")
        }
        tableView.reloadData()
    }

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories =  try context.fetch(request)
        } catch {
            print("error loading: \(error)")
        }
        tableView.reloadData()
    }
}
