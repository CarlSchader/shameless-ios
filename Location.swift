//
//  Location.swift
//  shameless-ios
//
//  Created by Carl Schader on 9/8/24.
//

import Foundation
import CoreLocation

extension Encodable {
    func toPayload() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

struct CoordinatePayload: Codable {
    let type: String = "gps-coordinate"
    let latitude: Double
    let longitude: Double
}

class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func didChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            manager.requestLocation()
            break
        case .authorizedAlways:
            break
        case .restricted .denied:
            break
        case .denied:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
        default:
            break
        }
    }
    
    func getLocationAuthorization(delegate: CLLocationManagerDelegate) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    func getLocationLogs() -> [Log] {
        var logs: [Log] = []
        guard let location: CLLocation = locationManager.location else {
            print("location is nil")
            return []
        }

        let time = Int64(location.timestamp.timeIntervalSince1970 * 1_000_000)
        
        do {
            logs.append(Log(time: time, payload: try CoordinatePayload(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude).toPayload()))
        } catch {
            print(error)
        }
        
        do {} catch { print(error) }
        
        return logs
    }

}



