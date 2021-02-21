//
//  BooksTableVC.swift
//  BooksApp
//
//  Created by MYMACBOOK on 21.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit

class BooksTableVC: UITableViewController {
    
    
    var catagoryName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = catagoryName
        let cellNib = UINib(nibName: "categoryBookCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cBooksCell")

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cBooksCell", for: indexPath) as! BooksTableViewCell


        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
