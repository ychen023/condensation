//
//  TopViewController.swift
//  condensation
//
//  Created by Ian Wang on 5/24/22.
//

import UIKit

struct TopGameInfo {
    let title: String
    let listPrice: String
    let currentPrice: String
    let rate: String
    let gameID: String
    let image: UIImageView
}

class TopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var TopGameTable: UITableView!
    var curGameID: String!
    var gameTitle: String!
    var currentPrice : String!
    var lowPrice : String!
//    var retailPrice: String!
    
    var topGame : [TopGameInfo] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topGame.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        cell.config(GameName: topGame[indexPath.row].title, CurrentPrice: topGame[indexPath.row].currentPrice, ListedPrice: topGame[indexPath.row].listPrice, GameRating: topGame[indexPath.row].rate, GameImage: topGame[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curGameID = topGame[indexPath.row].gameID
        gameTitle = topGame[indexPath.row].title
        currentPrice = topGame[indexPath.row].currentPrice
//        lowPrice = topGame[indexPath.row].lowPrice
//        retailPrice = topGame[indexPath.row].currentPrice

        print("User selected row at \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "TopDetail", sender: Any?.self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? DetailViewController {
                destination.gameID = curGameID
                destination.gameTitle = gameTitle!
                destination.cheapPrice = lowPrice
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TopGameTable.delegate = self
        TopGameTable.dataSource = self
        
        getData()
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        
        TopGameTable.register(nib, forCellReuseIdentifier: "GameTableViewCell")
        TopGameTable.rowHeight = 80.0
    }
    
    @objc func updateTimer() {
        self.TopGameTable.reloadData()
    }
    
    var game : [Game] = []
    var urlString = "https://www.cheapshark.com/api/1.0/deals?sortBy+reviews"
    

    
    fileprivate func getData() {
        var checkUnique = [""]
        
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
                            let topGames =  try JSONSerialization.jsonObject(with: data!) as! NSArray
                            print("start")
                            
                            DispatchQueue.main.async {
                                for i in 0..<topGames.count {

                                    let curr = topGames[i] as! NSDictionary
                                    print(curr)
                                    let temp4 = UIImageView()
                                    temp4.downloaded(from: URL(string: curr["thumb"] as! String)!)

                                    if self.topGame.count < 20 {
                                        for i in 0..<checkUnique.count {
                                            if checkUnique.contains(curr["title"] as! String) {
                                                print("contains")
                                            } else { // exist
                                                self.topGame.append(TopGameInfo(title: curr["title"] as! String, listPrice: curr["normalPrice"] as! String, currentPrice: curr["salePrice"] as! String, rate: curr["dealRating"] as! String, gameID: curr["gameID"] as! String, image: temp4))
                                                checkUnique.append(curr["title"] as! String)
                                            }
                                        }
                                    }
                                    

                                }
                                
                                
                                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: false)
//                                self.TopGameTable.reloadData()
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
