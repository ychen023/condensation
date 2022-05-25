//
//  ViewController.swift
//  condensation
//
//  Created by Yilin Chen on 5/24/22.
//

import UIKit

class ViewController: UIViewController {
    
    var urlString = "https://www.cheapshark.com/api/1.0/deals"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    fileprivate func getData() {
            guard let url = URL.init(string: urlString) else {
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
                            print(questions)
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

