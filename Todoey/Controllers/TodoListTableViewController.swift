//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Barnes on 3/1/19.
//  Copyright © 2019 Eric Barnes. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    let cellID = "TodoListItemCell"
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem1 = Item()
        newItem1.title = "unlock doors"
        itemArray.append(newItem1)

        let newItem2 = Item()
        newItem2.title = "activate pack-a-punch"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "build shield"
        itemArray.append(newItem3)

        if let items = defaults.array(forKey: "TodoListArray") as? [Item] { // retrieve saved items
            itemArray = items
        }

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

        tableView.reloadData() // forces tableview to recall its datasource methods again
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey item", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.setValue(self.itemArray, forKey: "TodoListItems")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            // code ran when textField is created
            alertTextField.placeholder = "Add new item"
            textField = alertTextField

        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

