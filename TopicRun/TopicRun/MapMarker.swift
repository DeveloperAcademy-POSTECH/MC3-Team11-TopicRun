//
//  MapMarker.swift
//  TopicRun
//
//  Created by Jaehwa Noh on 2022/07/21.
//

import Foundation
import MapKit


class MapMarker: NSObject, MKAnnotation {
    var keyword: [String]
    var subject: String
    var coordinate: CLLocationCoordinate2D
    var isVisit: Bool
    
    init (
        keyword: [String],
        subject: String,
        coordinate: CLLocationCoordinate2D,
        isVisit: Bool
    ) {
        self.keyword = keyword
        self.subject = subject
        self.coordinate = coordinate
        self.isVisit = isVisit

    }
    
}
