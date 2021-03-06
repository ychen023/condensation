//
//  DetailViewController.swift
//  condensation
//
//  Created by Yilin Chen on 5/31/22.
//

import UIKit
import Foundation
import SystemConfiguration
import MessageUI


struct DealInfo {
    let StoreName : String
//    let Image : UIImageView
    let Price : String
}



class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
   }
    
    
    var allStores : [String:String] = [:]
    
    @IBOutlet weak var GameTitle: UILabel!
    @IBOutlet weak var GameImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var FavoriteButton: UIButton!
    @IBOutlet weak var SharingButton: UIButton!
    
    
    var gameID : String!
    var gameTitle : String?
    var cheapPrice : String?
    var steamRatingText: String?
    var dealID : String!
    var retail: String?
    
    var urlString = "https://www.cheapshark.com/api/1.0/games?id="
    
    var stores : [DealInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        GameTitle.text = gameTitle
//        lowPrice.text = "current price: \(cheapPrice!)"
//        retailPrice.text = "normal price: \(retail!)"
        getStores()
        getData()
        tableView.rowHeight = 80.0
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTimer() {
        print("hello")
    }
    
    fileprivate func getData() {
        stores = []
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
                                    let storeID = curr["storeID"]! as! String
                                    let price = curr["price"]! as! String
                                    
                                    var storeName = self.allStores[storeID]
                                    if storeName == nil {
                                        storeName = "Loading"
                                    }
                                    
                                    
                                    self.stores.append(DealInfo(StoreName: storeName!, Price: price))
                                    
                                    
                                }
//                                let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: false)
                                self.tableView.reloadData()
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
        allStores = [:]
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
                                self.tableView.reloadData()
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
    
    @IBAction func addFavorite(_ sender: Any) {
//        print(gameID)
//        savedStores.append(gameID)
//        print(savedStores)
        
        
        
        do {
            DispatchQueue.main.async {
                self.FavoriteButton.setImage(UIImage(named: "filledHeart"), for: .highlighted)

                let archiveURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/favorites.archive")
                let urlString = NSHomeDirectory() + "/Documents/favorites.archive"
                
                let readthing = NSArray(contentsOf: archiveURL)
                if (readthing == nil) {
                    let temp : NSArray = [self.gameID ?? 0]
                    temp.write(toFile: urlString, atomically: true)
                } else {

                    let tempSave = NSArray(contentsOf: archiveURL)
                    let objCArrayTemp = NSMutableArray(array: tempSave ?? [0])

                    if var swiftArray = objCArrayTemp as NSArray as? [String] {
                        if !swiftArray.contains(self.gameID) {
                            swiftArray.append(self.gameID)
                        }
                        print(swiftArray)
                        let favorites = swiftArray as NSArray
                        favorites.write(toFile: urlString, atomically:true)
                    }
                }
                
//                test.write(toFile: urlString, atomically: true)
                
                

//
//                    print("Printing contents of archive")
//
//                    let readGames = NSArray(contentsOf: archiveURL)
//                    print(readGames)
                
//                let archivePath = NSHomeDirectory() + "/Documents/favorites.archive"
//                let favorites = self.savedStores as NSArray
//                favorites.write(toFile: archivePath, atomically:true)
//                print("saving")
//
//
//                let archiveURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/favorites.archive")
//                print(archiveURL)
//
//                let readGames = NSArray(contentsOf: archiveURL)
//                print(readGames)
//
//                print("reading")
//                print(readGames!)
            }
        }

        
    }
    

    @IBAction func shareSms(_ sender: Any) {
        //TODO: Will have to change the recipients
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            var temp = ""
            if dealID != nil {
                temp = "\n https://www.cheapshark.com/redirect?dealID=\(dealID!)"
            }
            controller.body = "There is a deal on \(gameTitle!)! \(temp)"
            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "stores", for: indexPath)
        cell.textLabel?.text = stores[indexPath.row].StoreName
        cell.detailTextLabel?.text = stores[indexPath.row].Price
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("User selected row at \(indexPath)")
        _ = tableView.cellForRow(at: indexPath)
    }

}
