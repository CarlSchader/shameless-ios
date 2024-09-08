//
//  Location.swift
//  shameless-ios
//
//  Created by Carl Schader on 9/8/24.
//

import Foundation
import CoreLocation

let locationManager = CLLocationManager()

func getLocationAuthorization(delegate: CLLocationManagerDelegate) {
    locationManager.requestAlwaysAuthorization()
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
}

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
