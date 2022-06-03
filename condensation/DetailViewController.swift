//
//  DetailViewController.swift
//  condensation
//
//  Created by Yilin Chen on 5/31/22.
//

import UIKit


struct DealInfo {
    let StoreName : String
//    let Image : UIImageView
    let Price : String
}



class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allStores : [String:String] = [:]
    
    @IBOutlet weak var GameTitle: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var currPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var retailPrice: UILabel!
    @IBOutlet weak var GameRating: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var gameID : String!
    var gameTitle : String?
    var cheapPrice : String?
    var steamRatingText: String?

    var urlString = "https://www.cheapshark.com/api/1.0/games?id="
    
    var stores : [DealInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        GameTitle.text = gameTitle
        GameRating.text = steamRatingText
        lowPrice.text = cheapPrice
        getStores()
        getData()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTimer() {
        self.tableView.reloadData()
    }
    
    
    fileprivate func getData() {
        guard let url = URL.init(string: urlString + gameID) else {
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
                            let game =  try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                            print("start")
                            let deals = game["deals"] as! NSArray
                            DispatchQueue.main.async {
                                for i in 0..<deals.count {
                                    let curr = deals[i] as! NSDictionary
                                    var storeID = curr["storeID"]
                                    if storeID == nil {
                                        storeID = "0"
                                    }
                                    var price = curr["price"]
                                    if price == nil {
                                        price = "0"
                                    }
                                    self.stores.append(DealInfo(StoreName: self.allStores[storeID! as! String]!, Price: price! as! String))
                                    
                                    
                                }
                                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: false)
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
    
    fileprivate func getStores() {
        guard let url = URL.init(string: "https://www.cheapshark.com/api/1.0/stores") else {
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
                            let allStores =  try JSONSerialization.jsonObject(with: data!) as! NSArray
                            print("start")
                            DispatchQueue.main.async {
                                for i in 0..<allStores.count {
                                    let curr = allStores[i] as! NSDictionary
                                    let storeID = curr["storeID"]!
                                    let storeName = curr["storeName"]!
                                    self.allStores[storeID as! String] = storeName as? String
                                }
                                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: false)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "stores", for: indexPath)
        cell.textLabel?.text = "abc"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("User selected row at \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
    }

}
