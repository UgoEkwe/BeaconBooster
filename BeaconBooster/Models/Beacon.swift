//
//  Beacon.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/10/24.
//

import Foundation
import CoreLocation

/// Represents an ibeacon detected by the app.
struct Beacon: Identifiable {
    var id: UUID
    let major: Int
    let minor: Int
    let proximity: CLProximity
    let distance: Double
}
