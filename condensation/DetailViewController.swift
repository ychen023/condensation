//
//  DetailViewController.swift
//  condensation
//
//  Created by Yilin Chen on 5/31/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var GameTitle: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var currPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var retailPrice: UILabel!
    @IBOutlet weak var GameRating: UILabel!
    
    var gameID : String?
    var gameTitle : String?
    var cheapPrice : String?
    var steamRatingText: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameTitle.text = gameTitle
        GameRating.text = steamRatingText
        lowPrice.text = cheapPrice
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
