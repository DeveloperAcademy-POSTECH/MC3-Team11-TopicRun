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
    @IBOutlet var userLocationButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goUserLocation(_ sender: Any) {
        
        mapView.centerToLocation(locationManager.location ?? CLLocation(latitude: 36.0138857, longitude: 129.3231836), regionRadius: mapView.radius)
        
        
    }
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var label: PaddingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        
        //Setting the round (optional)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = label.frame.height / 2
        
        //Setting the padding label
        label.edgeInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
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
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
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
    
    //    func topCenterCoordinate() -> CLLocationCoordinate2D {
    //        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    //    }
    //
    //    func currentRadius() -> Double {
    //        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
    //        let topCenterCoordinate = self.topCenterCoordinate()
    //        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
    //        return centerLocation.distance(from: topCenterLocation)
    //    }
    
    var topLeftCoordinate: CLLocationCoordinate2D{
        return convert(CGPoint.zero, toCoordinateFrom: self)
        
    }
    var radius: CLLocationDistance{
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        
        let topLeftLocation = CLLocation(latitude: topLeftCoordinate.latitude, longitude: topLeftCoordinate.longitude)
        
        return centerLocation.distance(from: topLeftLocation)
        
    }
    
}

