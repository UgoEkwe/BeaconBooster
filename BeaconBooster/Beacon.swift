//
//  Beacon.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/10/24.
//

import Foundation
import CoreLocation

struct Beacon: Identifiable {
    let id: UUID
    let major: Int
    let minor: Int
    let proximity: CLProximity
    let accuracy: Double
}
