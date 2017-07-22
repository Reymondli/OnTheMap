//
//  ListViewController.swift
//  OnTheMap1
//
//  Created by ziming li on 2017-07-16.
//  Copyright © 2017 ziming li. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController {
    func showList() {
        self.tableView.reloadData()
    }
    
    // MARK: Table Cell Count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTMData.sharedInstance().studentList.count
    }
    
    // MARK: Define Cell Content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = OTMData.sharedInstance().studentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OTMCell")!
        
        cell.imageView?.image = UIImage(named: "icon-pin")
        cell.textLabel?.text = "\(student.firstName ?? "") \(student.lastName ?? "")"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
        
    }
    
    // MARK: Launch Cell's URL when selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: OTMData.sharedInstance().studentList[indexPath.row].mediaURL!) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
