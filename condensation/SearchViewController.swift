//
//  SearchViewController.swift
//  condensation
//
//  Created by Jason Nguyen on 6/6/22.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBarOutlet: UITextField!
    @IBAction func searchBar(_ sender: Any) {
        searchName(searchBarOutlet.text!)
    }
    @IBOutlet weak var searchTableView: UITableView!
    var curGameID: String!
    var gameTitle: String!
    var lowPrice : String!
    var currentPrice : String!
    
    var tempGames : [String] = []
    
    var gameInfo : [(String, String, UIImageView)] = []
    
    var myUrl = "https://www.cheapshark.com/api/1.0/games?ids="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = gameInfo[indexPath.row].1
        cell.imageView?.image = gameInfo[indexPath.row].2.image
        return cell
    }
    
    @objc func updateTimer2() {
        self.searchTableView.reloadData()
    }
    
    @objc func updateTimer() {
        self.searchId()
    }
    
    fileprivate func searchName(_ name : String) {
        // set tempGames to empty
        tempGames = []
        gameInfo = []
        myUrl = "https://www.cheapshark.com/api/1.0/games?ids="
        guard let url = URL.init(string: "https://www.cheapshark.com/api/1.0/games?title=\(name)&limit=25&exact=0") else {
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
                            let results = try JSONSerialization.jsonObject(with: data!) as! NSArray
                            DispatchQueue.main.async {
                                for i in 0..<results.count {
                                    let curr = results[i] as! NSDictionary
                                    self.tempGames.append(curr["gameID"] as! String)
                                    print(curr["external"])
                                }
                                self.searchId()
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

    func searchId() {
        // set tempGames to empty
        
        for i in 0..<tempGames.count {
            myUrl += tempGames[i] + ","
        }
        
        myUrl = String(myUrl.dropLast())
        
        guard let url = URL.init(string: myUrl) else {
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
                            let favGames =  try JSONSerialization.jsonObject(with: data!) as! NSDictionary
                            DispatchQueue.main.async {
                                for gameID in favGames {
                                    let value = gameID.value as! NSDictionary
                                    let info = value["info"]! as! NSDictionary
                                    let title = info["title"]!
                                    let temp3 = UIImageView()
                                    temp3.downloaded(from: URL(string: info["thumb"] as! String)!)
                                    
                                    self.gameInfo.append((gameID.key as! String, title as! String, temp3))
                                }
                                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer2), userInfo: nil, repeats: false)
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
