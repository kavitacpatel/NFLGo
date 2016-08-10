//
//  DetailViewController.swift
//  NFLGo
//
//  Created by kavita patel on 7/28/16.
//  Copyright © 2016 kavita patel. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    var user: String = ""
    @IBOutlet weak var userLbl: UILabel!
    var locationManager: CLLocationManager!
    var Home = "33323 Irongate drive, Leesburg, Fl"
    var homeLocation = CLLocation()
    var geoCoder = CLGeocoder()
    var homeCoordination = CLLocationCoordinate2D()
    var newCoordination = CLLocationCoordinate2D()
    let dropPin = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var postalcode: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var locality: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var sublocality: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var subThoroughfare: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        //locationManager.requestAlwaysAuthorization()
        userLbl.text = user
        mapView.showsUserLocation = true
        geoCoder.geocodeAddressString(Home) { (placemarks: [CLPlacemark]?, err: NSError?) in
            if let placemark = (placemarks?[0])
            {
                self.homeCoordination = (placemark.location?.coordinate)!
                self.dropPin.coordinate = (placemark.location?.coordinate)!
                self.homeLocation = CLLocation(latitude: self.homeCoordination.latitude, longitude: self.homeCoordination.longitude)
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        dropPin.title = Home
        mapView.addAnnotation(dropPin)
        return nil
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.last
        {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            newCoordination = location.coordinate
            let distance: CLLocationDistance = location.distance(from: homeLocation)
            
            if distance > 300
            {
                distanceLbl.text = "You are far from Home"
            }
            if distance < 300 && distance > 40
            {
                distanceLbl.text = "You are near somewhere from Home"
            }
            if distance < 40
            {
                distanceLbl.text = "You are at Home"
            }
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if (error != nil)
                {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                else
                {
                    let pm = (placemarks?[0])! as CLPlacemark
                    self.displayLocationInfo(placemark: pm)
                }
            }
        }
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        postalcode.text = placemark.postalCode
        area.text = placemark.administrativeArea
        locality.text = placemark.locality
        country.text = placemark.country
        sublocality.text = placemark.subLocality
        subThoroughfare.text = placemark.subThoroughfare
    }
    
    @IBAction func checkin(_ sender: AnyObject)
    {
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.startUpdatingLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to get current location.")
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways
        {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)
            {
                if CLLocationManager.isRangingAvailable()
                {
                    // do stuff
                }
            }
        }
    }
}
