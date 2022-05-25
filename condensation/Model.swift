//
//  Model.swift
//  condensation
//
//  Created by Jason Nguyen on 5/24/22.
//

import Foundation
import UIKit

class Game {
    var title : String
    var rating : String
    var salePrice : String
    var normalPrice : String
    var image : String
    
    init(_ title : String, _ rating : String, _ salePrice : String, _ normalPrice : String, _ image : String) {
        self.title = title
        self.rating = rating
        self.salePrice = salePrice
        self.normalPrice = normalPrice
        self.image = image
    }
}
