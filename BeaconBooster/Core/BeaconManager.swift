//
//  BeaconManager.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/10/24.
//

import Foundation
import SwiftUI
import CoreLocation

/* Manages beacon proximity readings using Core Location. Scans for multiple beacon UUIDs.
   Could extend functionality by letting users add new UUIDs dynamically. Could improve error handling. */
class BeaconManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    
    @Published var detectedBeacons: [Beacon] = []
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    /// Creates and scans  regions using set UUIDs
    func startScanning() {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
              CLLocationManager.isRangingAvailable() else { return }
        
        // Seems to be the correct UUID
        let uuids = [
            "D546DF97-4757-47EF-BE09-3E2DCBDD0C77"
        ]
        
        // create and monitor regions for each UUID
        for uuidString in uuids {
            guard let uuid = UUID(uuidString: uuidString) else { continue }
            let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: uuidString)
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startScanning()
        }
    }
    
    /* Manages beacon range updates and calculates distance using its  rssi values
     Adds new beacon to the array or update its values if it exists */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            let updatedBeacon = Beacon(
                id: beacon.uuid,
                major: beacon.major.intValue,
                minor: beacon.minor.intValue,
                proximity: beacon.proximity,
                distance: beacon.rssi.distanceFromRSSI()
            )
            
            if let index = detectedBeacons.firstIndex(where: { $0.id == updatedBeacon.id }) {
                detectedBeacons[index] = updatedBeacon
            } else {
                detectedBeacons.append(updatedBeacon)
            }
        }
    }
}

/// Beacon proximity state descriptions
extension CLProximity {
    var description: String {
        switch self {
        case .unknown: return "Unknown"
        case .far: return "Far"
        case .near: return "Near"
        case .immediate: return "Immediate"
        @unknown default: return "Unknown"
        }
    }
}
