//
//  Books.swift
//  BooksApp
//
//  Created by MYMACBOOK on 21.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import Foundation

class Books {

    var title: String?
    var author: String?
    var publisher: String?
    var description: String?
    
    
    init() {
    }
    
    init(title: String, author: String, publisher: String, description: String) {
        self.title = title
        self.author = author
        self.publisher = publisher
        self.description = description
    }
}
