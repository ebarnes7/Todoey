//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Barnes on 3/1/19.
//  Copyright © 2019 Eric Barnes. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {

    var itemArray = ["unlock doors", "activate pack-a-punch", "build shield", "kill zombies"]
    let cellID = "TodoListItemCell"
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let items = defaults.array(forKey: "TodoListItems") as? [String] {
            itemArray = items
        }
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    // MARK: - Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Todoey item", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.itemArray.append(textField.text!)
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

