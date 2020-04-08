//
//  BooksTableViewCell.swift
//  GoogleBooksSearchApp
//
//  Created by Rentaro on 2020/03/11.
//  Copyright © 2020 Rentaro. All rights reserved.
//

import UIKit

class BooksTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        //もともと入っていた情報を再利用時にクリアする処理
        bookImage.image = nil
    }

}
