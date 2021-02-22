//
//  SearchVC.swift
//  BooksApp
//
//  Created by MYMACBOOK on 20.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var bookList = [Books]()
    var hasSearched = false
    var isLoading = false
    var dataTask: URLSessionDataTask?

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let cellNib = UINib(nibName: "booksCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "searchResultCell")
    }
    
  
}

//MARK: - Table View Delegates
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else if !hasSearched {
            return 0
        } else if bookList.count == 0 {
            return 0
        } else {
            return bookList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = bookList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchTableViewCell
        
        if let urlSmallThumbnail = URL(string: book.smallThumbnail!) {
            DispatchQueue.global().async {
                let st = try? Data(contentsOf: urlSmallThumbnail)
                      
                DispatchQueue.main.async {
                    cell.imageViewBook.image = UIImage(data: st!)
                    tableView.reloadData()
                }
            }
        }
        
        cell.labelName.text = book.title
        cell.labelPublisher.text = book.publisher
        cell.labelAuthor.text = book.author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - Search View Delegates
extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getMethod()
    }
    
    //MARK: - Fetching JSON data
      func getMethod() {
        
        if !searchBar.text!.isEmpty {
            
            searchBar.resignFirstResponder()
            dataTask?.cancel()
            isLoading = true
            tableView.reloadData()
            hasSearched = true
            bookList = []
            
            let encodedText = searchBar.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedText)") else {
                print("Error: Cannot create URL")
                return
            }
             
            let request = URLRequest(url: url)
            let session = URLSession.shared
          
            dataTask = session.dataTask(with: request, completionHandler:  { data, response, error in
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
                  
                    let title = i["volumeInfo"]["title"].string ?? "N/A"
                    let authors = i["volumeInfo"]["authors"].array ?? ["N/A"]
                    let author = authors[0].string ?? "N/A"
                    let description = i["volumeInfo"]["description"].string ?? "N/A"
                    let publisher = i["volumeInfo"]["publisher"].string ?? "N/A"
                    let smallThumbnail = i["volumeInfo"]["imageLinks"]["smallThumbnail"].string ?? ""
                    let thumbnail = i["volumeInfo"]["imageLinks"]["thumbnail"].string ?? ""
                      
                    let book = Books(title: title, author: author, publisher: publisher, description: description, smallThumbnail: smallThumbnail, thumbnail: thumbnail)
                        
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.bookList.append(book)
                        self.tableView.reloadData()
                    }
                }
            })
            dataTask?.resume()
        }
    }
}
