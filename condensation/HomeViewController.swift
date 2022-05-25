//
//  HomeViewController.swift
//  condensation
//
//  Created by Ian Wang on 5/24/22.
//

import UIKit

class HomeViewController: UIViewController {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    
    
    @IBOutlet weak var HomeTableView: UITableView!
    
    var urlString = "https://www.cheapshark.com/api/1.0/deals"
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        HomeTableView.delegate = self
//        HomeTableView.dataSource = self
        
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        HomeTableView.register(nib, forCellReuseIdentifier: "GameTableViewCell")
        
        getData()
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
                            for i in 0..<questions.count {
                                let curr = questions[i] as! NSDictionary
                                print(curr["title"]!)
                            }
//                            DispatchQueue.main.async {
//                                // make changes to UI
//                            }
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
