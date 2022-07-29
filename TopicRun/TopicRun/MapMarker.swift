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
    var topicImageName: String
    
    init (
        keyword: [String],
        subject: String,
        coordinate: CLLocationCoordinate2D,
        isVisit: Bool,
        topicImageName: String
    ) {
        self.keyword = keyword
        self.subject = subject
        self.coordinate = coordinate
        self.isVisit = isVisit
        self.topicImageName = topicImageName

    }
    
}
