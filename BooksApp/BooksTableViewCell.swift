//
//  BooksTableViewCell.swift
//  BooksApp
//
//  Created by MYMACBOOK on 21.02.2021.
//  Copyright © 2021 ElifKorkmaz. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewBook: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPublisher: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
