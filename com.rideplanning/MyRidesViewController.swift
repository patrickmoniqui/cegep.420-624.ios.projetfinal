//
//  MyRidesViewController.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-28.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import UIKit

class MyRidesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableRides: UITableView!

    
    var rides: [RideViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let userService = UserService()
        userService.GetLoggedUser { (user) in
        
            let rideService = RideService()
            rideService.GetMyRideList(username: user.username, completionHandler: {
                _rides in
                self.rides = _rides
                self.tableRides.reloadData()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rides.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = rides[indexPath.row].Title + " | " + String(describing: rides[indexPath.row].DateDepart)
        cell.detailTextLabel?.text = rides[indexPath.row].Description
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRide = rides[indexPath.row]
        performSegue(withIdentifier: "RideDetailSegue", sender: selectedRide.RideId)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RideDetailSegue" {
            let viewController : RideViewController = segue.destination as! RideViewController
            viewController.rideId = (sender as? Int)!
        }
    }
}
