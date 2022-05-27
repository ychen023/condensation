//
//  HomeViewController.swift
//  condensation
//
//  Created by Ian Wang on 5/24/22.
//

import UIKit
import SystemConfiguration

struct GameInfo {
    let title: String
    let listPrice: String
    let currentPrice: String
    let rate: String
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell
        
        cell.config(GameName: gameInfo[indexPath.row].title, CurrentPrice: gameInfo[indexPath.row].currentPrice, ListedPrice: gameInfo[indexPath.row].listPrice, GameRating: gameInfo[indexPath.row].rate)
        
        return cell
    }
    
    
    @IBOutlet weak var HomeTableView: UITableView!
    var game : [Game] = []
    var urlString = "https://www.cheapshark.com/api/1.0/deals"
    var gameInfo : [GameInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeTableView.delegate = self
        HomeTableView.dataSource = self
        
//        let categories = try! JSONDecoder().decode([GameTitle].self, from: data)
        
        getData()
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        HomeTableView.register(nib, forCellReuseIdentifier: "GameTableViewCell")
        HomeTableView.rowHeight = 80.0
        // Do any additional setup after loading the view.
    }
    

    
    fileprivate func getData() {
            guard let url = URL.init(string: urlString) else {
                print("no good")
                return
            }
            let session = URLSession.shared.dataTask(with: url) {data, response, error in
                if response != nil {
                    if (response! as! HTTPURLResponse).statusCode != 200 {
                        // if response is not 200
                        print("im sorry")
                    } else {
                        do {
                            let questions =  try JSONSerialization.jsonObject(with: data!) as! NSArray
                            print("start")

                            DispatchQueue.main.async {
                                for i in 0..<questions.count {
                                    
                                    let curr = questions[i] as! NSDictionary
                                    print(curr)
                                    self.gameInfo.append(GameInfo(title: curr["title"] as! String, listPrice: curr["salePrice"] as! String, currentPrice: curr["normalPrice"] as! String, rate: curr["dealRating"] as! String))
                                }
                                self.HomeTableView.reloadData()
                            }
                        } catch {
                            DispatchQueue.main.async {
                                print("something went wrong")
                            }
                        }
                    }
                }
            }
            session.resume()
        }

}
