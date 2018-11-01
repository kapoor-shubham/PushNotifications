//
//  ViewController.swift
//  PushNotificationsDemo
//
//  Created by Shubham Kapoor on 31/10/18.
//  Copyright © 2018 Shubham Kapoor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var notificationTableView: UITableView!
    
    var availableNotifications = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.stringArray(forKey: notificationList) != nil && (defaults.stringArray(forKey: notificationList)?.count)! > 0 {
            availableNotifications = defaults.stringArray(forKey: notificationList)!
            notificationTableView.dataSource = self
            notificationTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (defaults.stringArray(forKey: notificationList)?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.textLabel?.text = availableNotifications[indexPath.row]
        return cell
    }
}

