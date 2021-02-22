//
//  BooksTableVC.swift
//  BooksApp
//
//  Created by MYMACBOOK on 21.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import SwiftyJSON

class BooksTableVC: UITableViewController {
    
    var catagoryName: String!
    var data = [Books]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = catagoryName
        let cellNib = UINib(nibName: "categoryBookCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cBooksCell")
        
        getMethod(category: catagoryName)
    }
    
    func getMethod(category: String) {
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=subject:\(category)") else {
            print("Error: Cannot create URL")
            return
        }
           
        let request = URLRequest(url: url)
           
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                return
            }
               
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
               
            guard let response = response as? HTTPURLResponse, (200..<229) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
               
            let json = try! JSON(data: data)
            let items = json["items"].array!
            
            for i in items {
                let title = i["volumeInfo"]["title"].string
                let author = i["volumeInfo"]["authors"].array!.first!.string
                let description = i["volumeInfo"]["description"].string
                let publisher = i["volumeInfo"]["publisher"].string
                let smallThumbnail = i["volumeInfo"]["imageLinks"]["smallThumbnail"].string
                let thumbnail = i["volumeInfo"]["imageLinks"]["thumbnail"].string
                
                let b = Books(title: title!, author: author!, publisher: publisher!, description: description!, smallThumbnail: smallThumbnail!, thumbnail: thumbnail!)
                
                DispatchQueue.main.async {
                    self.data.append(b)
                    self.tableView.reloadData()
                }
            }
           } .resume()
       }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cBooksCell", for: indexPath) as! BooksTableViewCell
        
        if let urlThumbnail = URL(string: book.thumbnail!), let urlSmallThumbnail = URL(string: book.smallThumbnail!) {
            
            DispatchQueue.global().async {
                let st = try? Data(contentsOf: urlSmallThumbnail)
                
                DispatchQueue.main.async {
                    cell.imageViewBook.image = UIImage(data: st!)
                    tableView.reloadData()
                }
            }
        }
        
        cell.labelName.text = book.title
        cell.labelAuthor.text = book.author
        cell.labelPublisher.text = book.publisher
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
