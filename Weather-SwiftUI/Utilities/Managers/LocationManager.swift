//
//  LocationManager.swift
//  Weather-SwiftUI
//
//  Created by Shamil Bayramli on 28.05.24.
//

import SwiftUI
import CoreLocation

@MainActor
protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocationText(_ locationText: String)
    func didGiveError(error: Errors)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    var location: CLLocation?
    var authorizationStatus: CLAuthorizationStatus?
    var country: String?
    var city: String?
    var locationText = "Unknown"
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        self.location = latestLocation
        self.reverseGeocode(location: latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                Task { @MainActor in
                    self.delegate?.didGiveError(error: Errors.unableToComplete)
                }
                return
            }
            if let placemark = placemarks?.first {
                self.country = placemark.country
                self.city = placemark.locality
                self.locationText = self.getLocationText(city: self.city, country: self.country)
                
                Task { @MainActor in
                    self.delegate?.didUpdateLocationText(self.locationText)
                }
                
            } else {
                print("error")
            }
        }
    }
    
    func getLocationText(city: String?, country: String?) -> String
    {
        guard let city, let country else {return "Unknown"}
        return "\(city), \(country)"
    }

}

