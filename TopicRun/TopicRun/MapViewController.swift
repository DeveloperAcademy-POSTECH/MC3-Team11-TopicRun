//
//  MapViewController.swift
//  TopicRun
//
//  Created by Jaehwa Noh on 2022/07/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // Alert
        }
        
        mapView.showsUserLocation = true
        
        mapView.centerToLocation(locationManager.location ?? CLLocation(latitude: 36.0138857, longitude: 129.3231836))
        // back button hide.
        //        self.navigationItem.setHidesBackButton(true, animated: true)
        //        self.navigationItem.leftBarButtonItems = []
        //        self.navigationItem.hidesBackButton = true
        //         Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}


//36.0138857
//129.3231836

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000) {
            let coordinateRegion = MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius,
                longitudinalMeters: regionRadius
            )
            
            setRegion(coordinateRegion, animated: true)
        }
}
