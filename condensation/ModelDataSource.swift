//
//  ModelDataSource.swift
//  condensation
//
//  Created by Yilin Chen on 5/26/22.
//

//import UIKit
//
//class GameDataSource: NSObject, UITableViewDataSource {
//    var data : [Game] = []
//    init(_ elements : [Game]) {
//        data = elements
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count;
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell") as! GameTableViewCell
//
//        let currData = data[indexPath.row]
//        cell.GameName.text = currData.title
//
//        return cell
//    }
//
//}
