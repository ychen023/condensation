//
//  GameTableCellTableViewCell.swift
//  condensation
//
//  Created by Yilin Chen on 5/24/22.
//

import UIKit

class GameTableCellTableViewCell: UITableViewCell {
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var GameName: UILabel!
    @IBOutlet weak var CurrentPrice: UILabel!
    @IBOutlet weak var ListedPrice: UILabel!
    @IBOutlet weak var GameRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
