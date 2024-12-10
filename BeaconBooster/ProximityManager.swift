//
//  ProximityManager.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/10/24.
//

import Foundation
import SwiftUI
import CoreLocation

/* Manages beacon proximity readings using Core Location. Scans for multiple beacon UUIDs.
   Could extend functionality by letting users add new UUIDs dynamically. Could improve error handling. */
class ProximityManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager!
    
    @Published var detectedBeacons: [Beacon] = []
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    /// Creates and scans  regions using set UUIDs
    func startScanning() {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self),
              CLLocationManager.isRangingAvailable() else {
            print("Beacon monitoring or ranging is not available on this device.")
            return
        }
        
        // Either one seems to work.
        let uuids = [
            "FDA50693-A4E2-4FB1-AFCF-C6EB07647825",
            "D546DF97-4757-47EF-BE09-3E2DCBDD0C77"
        ]
        
        // create and monitor regions for each UUID
        for uuidString in uuids {
            guard let uuid = UUID(uuidString: uuidString) else {
                print("Invalid UUID: \(uuidString)")
                continue
            }
            let beaconRegion = CLBeaconRegion(uuid: uuid, identifier: uuidString)
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: beaconRegion.uuid))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startScanning()
        } else {
            print("Authorization denied: \(status)")
        }
    }
    
    /* Manages beacon range updates and calculates distance using its  rssi values
     Adds new beacon to the array or update its proximity values if it exists */
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            let updatedBeacon = Beacon(
                id: beacon.uuid,
                major: beacon.major.intValue,
                minor: beacon.minor.intValue,
                proximity: beacon.proximity,
                distance: calculateDistance(fromRSSI: beacon.rssi)
            )
            
            if let index = detectedBeacons.firstIndex(where: { $0.id == updatedBeacon.id }) {
                detectedBeacons[index] = updatedBeacon
            } else {
                detectedBeacons.append(updatedBeacon)
            }
        }
    }
    
    /// Calculates distance from RSSI
    private func calculateDistance(fromRSSI rssi: Int) -> Double {
        guard rssi != 0 else { return -1.0 }
        let ratio = Double(rssi) / Double(-59) // need a more accurate calibration value
        return pow(10.0, -ratio)
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
