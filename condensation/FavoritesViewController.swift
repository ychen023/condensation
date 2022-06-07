//
//  FavoritesViewController.swift
//  condensation
//
//  Created by Ian Wang on 5/24/22.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var FavTableView: UITableView!
    var curGameID: String!
    var gameTitle: String!
    var lowPrice : String!
    var currentPrice : String!
    
    var tempGames : [String] = []
    
    var gameInfo : [(String, String, UIImageView)] = []
    
    var myUrl = "https://www.cheapshark.com/api/1.0/games?ids="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FavTableView.dataSource = self
        FavTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tempGames = []
        gameInfo = []
        populateFavorites()
    }
    
    func populateFavorites() {
        let archiveURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/favorites.archive")
        let urlString = NSHomeDirectory() + "/Documents/favorites.archive"
        
        let readthing = NSArray(contentsOf: archiveURL)
        
        if readthing == nil {
            // put a label on the page that says it's empty
        } else {
            print(readthing!)
            for gameID in readthing! {
                self.tempGames.append(gameID as! String)
            }
        }
        
        if !tempGames.isEmpty {
            getFavs()
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SavedGames", for: indexPath)
        cell.textLabel?.text = gameInfo[indexPath.row].1
        cell.imageView?.image = gameInfo[indexPath.row].2.image
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // TODO: Get detail view to load in favorites pages
//        curGameID = topGame[indexPath.row].gameID
//        gameTitle = topGame[indexPath.row].title
//        currentPrice = topGame[indexPath.row].currentPrice
        
        print("User selected row at \(indexPath)")
//        let cell = tableView.cellForRow(at: indexPath)
//        self.performSegue(withIdentifier: "FavDetail", sender: Any?.self)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tempGames.remove(at: indexPath.row)
            gameInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //reading
            let archiveURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/favorites.archive")
            let urlString = NSHomeDirectory() + "/Documents/favorites.archive"
            let readthing = NSArray(contentsOf: archiveURL)
            
            
            
            //converting to swift array
            let tempSave = NSArray(contentsOf: archiveURL)
            let objCArrayTemp = NSMutableArray(array: tempSave ?? [0])

            if var swiftArray = objCArrayTemp as NSArray as? [String] {

                swiftArray.remove(at: indexPath.row)

                print(swiftArray)
                let favorites = swiftArray as NSArray
                favorites.write(toFile: urlString, atomically:true)
            }
            
            
            
            tableView.endUpdates()
        }
        
       
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destination = segue.destination as? DetailViewController {
                destination.gameID = curGameID
                destination.gameTitle = gameTitle!
                destination.cheapPrice = lowPrice
            }
        }
    
    @objc func updateTimer() {
        self.FavTableView.reloadData()
    }
    
    fileprivate func getFavs() {
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

}

