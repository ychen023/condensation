//
//  GameTableCellTableViewCell.swift
//  condensation
//
//  Created by Yilin Chen on 5/24/22.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var GameName: UILabel!
    @IBOutlet weak var CurrentPrice: UILabel!
    @IBOutlet weak var ListedPrice: UILabel!
    @IBOutlet weak var GameRating: UILabel!
    
    static let identifier = "GameTableViewCell"
    
    public func config(GameName name: String, CurrentPrice currPrice: String, ListedPrice listPrice: String, GameRating rate: String, GameImage image: UIImageView) {
        
        self.GameImage!.image = image.image
        self.GameName.text = name
        self.CurrentPrice.text = currPrice
        self.ListedPrice.text = listPrice
        self.GameRating.text = rate
        
        
        
        GameName.translatesAutoresizingMaskIntoConstraints = false
        GameName.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        GameName.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: -40).isActive = true
        
        ListedPrice.translatesAutoresizingMaskIntoConstraints = false
        ListedPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        ListedPrice.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        CurrentPrice.translatesAutoresizingMaskIntoConstraints = false
        CurrentPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        CurrentPrice.bottomAnchor.constraint(equalTo: ListedPrice.topAnchor).isActive = true
        
        GameImage.translatesAutoresizingMaskIntoConstraints = false
        GameImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        GameImage.trailingAnchor.constraint(equalTo: GameName.leadingAnchor).isActive = true
        GameImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        GameImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        GameRating.translatesAutoresizingMaskIntoConstraints = false
        GameRating.leadingAnchor.constraint(equalTo: GameImage.trailingAnchor).isActive = true
        GameRating.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
