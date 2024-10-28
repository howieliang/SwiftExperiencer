//
//  LocationManager.swift
//  SwiftExperiencer Watch App
//
//  Created by Julia Grill on 27.05.24.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var degrees: Double = 0
    @Published var location: CLLocationCoordinate2D?
    @Published var locations: [CLLocation]?
        
    override init() {
        super.init()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.distanceFilter = 2000
    }
    
    func requestLocation() {
        requestAuthorization()
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        self.locations = locations
        print("[LocationManager] Location updated:" , location ?? "")
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        //
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("[LocationManager] Application will not work properly")
        default:
            break
        }
    }
}
