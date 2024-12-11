//
//  iBeaconTab.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/11/24.
//

import SwiftUI

struct iBeaconTab: View {
    @ObservedObject var manager: BeaconManager
    
    var body: some View {
        VStack {
            if manager.authorizationStatus != .authorizedAlways &&
                manager.authorizationStatus != .authorizedWhenInUse {
                Text("Location access is required to detect iBeacons.")
                    .foregroundStyle(.red)
            }
            if manager.detectedBeacons.isEmpty {
                Text("Searching for iBeacons...")
                    .font(.headline)
                    .padding()
            } else {
                Text("Detected iBeacons")
                    .font(.headline)
                    .padding()
            }
            
            List(manager.detectedBeacons) { beacon in
                VStack(alignment: .leading) {
                    Text("UUID: \(beacon.id.uuidString)")
                        .foregroundStyle(.green)
                    Text("Proximity: \(beacon.proximity.description)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("Distance: \(String(format: "%.2f meters", beacon.distance))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        }
        .onAppear {
            manager.startScanning()
        }
    }
}

//#Preview {
//    iBeaconTab()
//}
