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
    let gameID: String
    let image: UIImageView
//    var retailPrice: String!
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var curGameID: String!
    var gameTitle: String!
    var currentPrice : String!
    var lowPrice : String!
//    var retailPrice: String!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as! GameTableViewCell
        
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        cell.config(GameName: gameInfo[indexPath.row].title, CurrentPrice: gameInfo[indexPath.row].currentPrice, ListedPrice: gameInfo[indexPath.row].listPrice, GameRating: gameInfo[indexPath.row].rate, GameImage: gameInfo[indexPath.row].image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curGameID = gameInfo[indexPath.row].gameID
        gameTitle = gameInfo[indexPath.row].title
        currentPrice = gameInfo[indexPath.row].currentPrice
//        lowPrice = gameInfo[indexPath.row].lowPrice
//        retailPrice = gameInfo[indexPath.row].currentPrice
        
        print("User selected row at \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        self.performSegue(withIdentifier: "Detail", sender: Any?.self)
        tableView.deselectRow(at: indexPath, animated: true)
       
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? DetailViewController {
                destination.gameID = curGameID
                destination.gameTitle = gameTitle!
                destination.cheapPrice = lowPrice
            }
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
    
    @objc func updateTimer() {
        self.HomeTableView.reloadData()
    }
    
    fileprivate func getData() {
        var checkUniqueName = [""]

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
//                                    print(curr)
                                    let temp = curr["steamRatingText"] as? String
                                    var temp2 = "unavailable"
                                    if temp != nil {
                                        temp2 = temp!
                                    }
                                    let temp3 = UIImageView()
                                    temp3.downloaded(from: URL(string: curr["thumb"] as! String)!)
                                    
                                    for i in 0..<checkUniqueName.count {
                                        if checkUniqueName.contains(curr["title"] as! String) {
                                            print("contains")
                                        } else {
                                            self.gameInfo.append(GameInfo(title: curr["title"] as! String, listPrice: curr["salePrice"] as! String, currentPrice: curr["normalPrice"] as! String, rate: curr["dealRating"] as! String, gameID: curr["gameID"] as! String, image: temp3))
                                            checkUniqueName.append(curr["title"] as! String)
                                        }
                                    }

                                }
                                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: false)
//                                self.HomeTableView.reloadData()
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


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
