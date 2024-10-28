//
//  CLLocationExtension.swift
//  SwiftExperiencer
//
//  Created by Julia Grill on 19.06.24.
//

import Foundation
import CoreLocation

extension CLLocation {
    static func convertCoordinatesToAddress(longitude: Double, latitude: Double, completionHandler: @escaping (CLPlacemark) -> ()) -> Void {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemarks, error in
            completionHandler(placemarks![0])
        }
    }
}
