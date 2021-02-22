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

    
    struct TableView {
        struct CellIdentifiers {
            static let booksCell = "booksCell"
            static let nothingFoundCell = "nothingFoundCell"
            static let loadingCell = "loadingCell"
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var cellNib = UINib(nibName: TableView.CellIdentifiers.booksCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.booksCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder()
    }
  
}

//MARK: - Table View Delegates
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if bookList.count == 0 {
            return 1
        } else {
            return bookList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
        } else if bookList.count == 0 {
            
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            
        } else {
            let book = bookList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.booksCell, for: indexPath) as! SearchTableViewCell
        
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
                let items = json["items"].array ?? []
                if !items.isEmpty {
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
                } else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                }
            })
            dataTask?.resume()
        }
    }
}
