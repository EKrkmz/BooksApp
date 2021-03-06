//
//  ViewController.swift
//  BooksApp
//
//  Created by MYMACBOOK on 20.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollViewImages: UIScrollView!
    @IBOutlet weak var collectionViewHRB: UICollectionView!
    @IBOutlet weak var tableViewCategories: UITableView!

    var scroolViewBookImages = ["book1", "book2", "book3", "book4"]
    var frame = CGRect.zero
    var categories = ["Art", "Business & Economics", "Computers", "Drama", "Education", "Fiction", "Psychology", "Science"]
    
    var realm = try! Realm()
    var mustReadResult: Results<MustRead>!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpScreens()
        scrollViewImages.delegate = self
        collectionViewHRB.delegate = self
        collectionViewHRB.dataSource = self
        tableViewCategories.delegate = self
        tableViewCategories.dataSource = self
        
        let design = UICollectionViewFlowLayout()
        let w = collectionViewHRB.frame.size.width
        design.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let cellWidth = (w-28)/4
        design.itemSize = CGSize(width: cellWidth, height: cellWidth*1.3)
        design.minimumInteritemSpacing = 10
        design.minimumLineSpacing = 10
        design.scrollDirection = .horizontal
        collectionViewHRB.collectionViewLayout = design
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mustReadResult = realm.objects(MustRead.self)
        collectionViewHRB.reloadData()
    }
    
    @IBAction func showAll(_ sender: Any) {
       
    }
    //MARK:- Helper Methods
    
    func setUpScreens() {
        for i in 0..<scroolViewBookImages.count {
            
            frame.origin.x = scrollViewImages.frame.size.width * CGFloat(i)
            frame.size = scrollViewImages.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: scroolViewBookImages[i])
            
            scrollViewImages.addSubview(imageView)
        }
        
        scrollViewImages.contentSize = CGSize(width: (scrollViewImages.frame.size.width * CGFloat(scroolViewBookImages.count)), height: scrollViewImages.frame.size.height)
        
        scrollViewImages.delegate = self
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        if segue.identifier == "showBooks" {
            let controller = segue.destination as! BooksTableVC
            controller.catagoryName = categories[index!]
        }
        
        if segue.identifier == "showAll" {
            let controller = segue.destination as! MustReadTableVC
            controller.books = mustReadResult
        }
    } 

}
//MARK: - Collection View Delegates
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mustReadResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let book = mustReadResult[indexPath.row].name
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mustReadCell", for: indexPath) as! MustReadCollectionViewCell
        
        cell.label.text = book
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.5 
        
        return cell
    }
}
//MARK:- Table View Delegates
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath) as! CategoriesTableViewCell
        
        cell.labelCategory.text = "\(categories[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showBooks", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
}
