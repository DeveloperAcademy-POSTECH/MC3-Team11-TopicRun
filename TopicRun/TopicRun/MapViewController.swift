//
//  MapViewController.swift
//  TopicRun
//
//  Created by Jaehwa Noh on 2022/07/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var runButton: UIButton!
    @IBOutlet weak var willRunView: UIView!
    @IBOutlet weak var didRunView: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var userLocationButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    private var isStart = false
    
    @IBAction func goBack(_ sender: Any) {
        // 뒤로 가기 버튼
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func goUserLocation(_ sender: Any) {
        // 현재 위치 버튼 마지막 위치 정보가 없으면 36.0138857, 129.32318336으로 이동. regionRadius는 지도 확대 정도.
        mapView.centerToLocation(locationManager.location ?? CLLocation(latitude: 36.0138857, longitude: 129.3231836), regionRadius: mapView.radius)
    }
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //36.014986
        //129.325184
        
        // 첫 번째 마커
        mapView.delegate = self
        let firstPlace = MapMarker(keyword: ["건강","운세","돈"], subject: "건강 운세로 돈을 벌어라.", coordinate: CLLocationCoordinate2D(latitude: 36.015886, longitude: 129.325184), isVisit: false)
        
        //36.012986
        //129.325784
        
        // 두 번째 마커
        let secondPlace = MapMarker(keyword: ["매미","여름","얼음"], subject: "여름에 매미에게 얼음을 보여주자", coordinate: CLLocationCoordinate2D(latitude: 36.012986, longitude: 129.325784), isVisit: false)
        
        // 지오펜스 설정.
        monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: 36.012986, longitude: 129.325784), identifier: "second")
        monitorRegionAtLocation(center: CLLocationCoordinate2D(latitude: 36.015886, longitude: 129.325184), identifier: "first")
        
        // 위치 권한 사용자에게 묻기.
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            // 사용자 현재 위치 계속 업데이트
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        } else {
            let alert = UIAlertController(title: "위치 권한", message: "위치 권한이 없습니다. 위치 정보가 없으면 앱이 작동되지 않습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            //            mapView.showsUserLocation = false
        }
        
        // 지도 위치 권한 확인
        switch locationManager.authorizationStatus {
        case .restricted, .denied:
            // 지도 위치 권한이 없으면 경고 창
            print("no permission")
            let alert = UIAlertController(title: "위치 권한", message: "위치 권한이 없습니다. 위치 정보가 없으면 앱이 작동되지 않습니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
            mapView.showsUserLocation = false
        case .notDetermined:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        if isStart {
            willRunView.isHidden = true
            didRunView.isHidden = false
        } else {
            willRunView.isHidden = false
            didRunView.isHidden = true
        }
        
        // 처음 지도 화면 이동.
        mapView.centerToLocation(locationManager.location ?? CLLocation(latitude: 36.0138857, longitude: 129.3231836))
        
        // 토픽 마커 추가.
        mapView.addAnnotation(firstPlace)
        mapView.addAnnotation(secondPlace)
        
        // back button hide.
        // 뒤로 가기 버튼 숨김
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String) {
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // 위치에 어느정도 근접하면 작동할지 설정.
            let maxDistance = CLLocationDistance(1)
            
            //            let maxDistance = locationManager.maximumRegionMonitoringDistance
            // 36.014686
            // 129.325384
            let region = CLCircularRegion(center: center, radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            locationManager.startMonitoring(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // 위치에 도착하면 동작하는 트리거
        if let region = region as? CLCircularRegion {
            let identifier = region.identifier
            //            triggerTaskAssociateWithRegionIdentifier(regionID: identifier)
            let alert = UIAlertController(title: "들어감", message: "들어감 내용 \(identifier) \(mapView.userLocation.coordinate)", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // 마커들 확인.
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            // 사용자 용 마커 핀
            //            let pin = mapView.view(for: annotation) as? MKPinAnnotationView ?? MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            //            pin.pinTintColor = UIColor.purple
            
            // 사용자 용 마커 핀
            let markerImage = UIImage(named: "userIcon")
            annotationView.image = markerImage
            
            return annotationView
        } else {
            // 주제 용 마커
            let markerImage = UIImage(named: "heartMarker")
            annotationView.image = markerImage
        }
        return annotationView
    }
    @IBAction func clickRunButton(_ sender: Any) {
        
        isStart = true
        
        willRunView.isHidden = true
        didRunView.isHidden = false
        
    }
    @IBAction func clickStopButton(_ sender: Any) {
        
        isStart = false

        willRunView.isHidden = false
        didRunView.isHidden = true
        
    }
}


//36.0138857
//129.3231836

//36.014986
//129.325184

//36.012986
//129.325784

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

