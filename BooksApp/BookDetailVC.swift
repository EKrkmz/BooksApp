//
//  BookDetailVC.swift
//  BooksApp
//
//  Created by MYMACBOOK on 22.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit

class BookDetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var bookName: String?
    var book = [Books]()
    var page = "Detail"
    
    struct TableView {
        struct CellIdentifiers {
            static let detailCell = "detailCell"
            static let descriptionCell = "descriptionCell"
            static let commentsCell = "commentsCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = bookName
        tableView.delegate = self
        tableView.dataSource = self
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.detailCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.detailCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.descriptionCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.descriptionCell)
        
      //  labelBookTitle.text = book.first?.author
        //bunları düzelt optinal binding yap
        let url = URL(string: book[0].thumbnail!)
        let data = try! Data(contentsOf: url!)
        imageView.image = UIImage(data: data)

    }
    @IBAction func segments(_ sender: UISegmentedControl) {
        tableView.reloadData()
        switch sender.selectedSegmentIndex {
        case 0:
            page = "Detail"
        case 1:
            page = "Description"
        case 2:
            page  = "Comments"
        default:
            break
        }
    }
    
}

extension BookDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if page == "Detail" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.detailCell, for: indexPath) as! DetailTableViewCell
                
                cell.labelAuthorName.text = book[0].author
                cell.labelTitleName.text = book[0].title
                cell.labelPublisherName.text = book[0].publisher
                
                return cell
            
        } else if page == "Description" {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.descriptionCell, for: indexPath) as! DescriptionTableViewCell
            
            cell.textView.text = book[0].description
            return cell
            
        } else {
            //yorumlar kısmını yapınca burayı düzelt
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.descriptionCell, for: indexPath) as! DescriptionTableViewCell
            
            cell.textView.text = book[0].description
            return cell
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    

}
