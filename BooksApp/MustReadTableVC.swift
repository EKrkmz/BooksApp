//
//  MustReadTableVC.swift
//  BooksApp
//
//  Created by MYMACBOOK on 25.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import RealmSwift

class MustReadTableVC: UITableViewController {
        
    @IBOutlet weak var label: UILabel!
    var books: Results<MustRead>!
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = books[indexPath.row].name
        let cell = tableView.dequeueReusableCell(withIdentifier: "mustReadCell", for: indexPath)
        cell.textLabel?.text = book
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let mustReadBook = realm.objects(MustRead.self)
            
            try! realm.write {
              realm.delete(mustReadBook[indexPath.row])
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
