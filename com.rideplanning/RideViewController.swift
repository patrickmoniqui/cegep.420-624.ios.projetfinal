//
//  RideViewController.swift
//  com.rideplanning
//
//  Created by Patrick Moniqui on 17-11-23.
//  Copyright © 2017 Patrick Moniqui. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class RideViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var lblTitle: UITextField!
    @IBOutlet weak var lblDesc: UITextField!
    @IBOutlet weak var lblLevel: UITextField!
    @IBOutlet weak var lblCreator: UITextField!
    @IBOutlet weak var lblDates: UITextField!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var btnEdit: UIBarButtonItem!

    var rideId: Int? = nil
    var ride : RideViewModel?
    var rideService = RideService()
    var userService = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if rideId != nil {
            rideService.GetRideById(rideId: rideId!, completionHandler: { _ride in
                self.ride = _ride
                self.LoadRide()
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LoadRide()
    {
        userService.GetLoggedUser { (_user) in
            let username = _user
            if(username.userId != self.ride?.Creator.userId)
            {
                self.btnEdit.isEnabled = false
            }
        }
        
        lblTitle.text = (self.ride?.Title)!
        lblDesc.text = self.ride?.Description
        lblLevel.text = self.ride?.Level?.name
        lblCreator.text = self.ride?.Creator.username
        lblDates.text = (self.ride?.DateDebutString)! + " to " + (self.ride?.DateFinString)!
        
        if(ride?.Trajet != nil)
        {
            LoadMap()
        }
    }
    
    func LoadMap()
    {
        self.mapKit.showsUserLocation = true
        
        var gpsPoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for point in (ride?.Trajet?.GpsPoints)!
        {
            var points = point.components(separatedBy: ",")
            
            if let lat = NumberFormatter().number(from: points[0])?.doubleValue, let lon = NumberFormatter().number(from: points[1])?.doubleValue {
                let _point = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                gpsPoints.append(_point)
            }
        }
        
        let sourceLocation = gpsPoints[0]
        let destinationLocation = gpsPoints[1]
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
       
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Start"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Finish"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapKit.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapKit.add((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RideEditSegue" {
            let viewController : CreateEditRideViewController = segue.destination as! CreateEditRideViewController
            viewController.editRideId = (sender as? Int!)
        }
    }
    
    @IBAction func btnEdit_Touch(_ sender: Any) {
        performSegue(withIdentifier: "RideEditSegue", sender: self.ride?.RideId)
    }
    
}
