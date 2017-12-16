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
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var mapKit: MKMapView!

    var rideId: Int? = nil
    var ride : SingleRideViewModel?
    var rideService = RideService()
    
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
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .full
        
        let dateFrom = myFormatter.string(from: (self.ride?.DateDepart)!)
        
        lblTitle.text = (self.ride?.Title)! + " | " + dateFrom
        lblDesc.text = self.ride?.Description
        
        LoadMap()
    }
    
    func LoadMap()
    {
        self.mapKit.showsUserLocation = true
        
        var gpsPoints: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for point in (ride?.Trajet.GpsPoints)!
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
            
            let rect = route.polyline.boundingMapRect
            self.mapKit.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
}