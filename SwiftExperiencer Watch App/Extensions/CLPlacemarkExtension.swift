//
//  CLPlacemarkExtension.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 26.07.24.
//

import Foundation
import MapKit

extension CLPlacemark {
    func formatAddress() -> String {
        var addressString = ""
        if let street = self.thoroughfare {
            addressString += street + ", "
        }
        if let city = self.locality {
            addressString += city + ", "
        }
        if let state = self.administrativeArea {
            addressString += state + ", "
        }
        if let postalCode = self.postalCode {
            addressString += postalCode + ", "
        }
        if let country = self.country {
            addressString += country
        }
        return addressString
    }
}
