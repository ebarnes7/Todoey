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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()

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
            let newItem = Item()
            newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error: \(error)")
        }
        tableView.reloadData()
    }

    func loadItems() {

        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding: \(error)")
            }
        }
    }

}

