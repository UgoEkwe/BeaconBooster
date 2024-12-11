//
//  Eddystone.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/11/24.
//

import Foundation

/// Represents an Eddystone beacon detected by the app.
struct Eddystone: Identifiable {
    var id: String
    let displayName: String
    let distance: Double
}
