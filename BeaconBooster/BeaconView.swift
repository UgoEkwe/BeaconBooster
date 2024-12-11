//
//  BeaconView.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/10/24.
//

import SwiftUI

struct BeaconView: View {
    @StateObject private var manager = BeaconManager()
    
    var body: some View {
        VStack {
            if manager.authorizationStatus != .authorizedAlways &&
                manager.authorizationStatus != .authorizedWhenInUse {
                Text("Location access is required to detect iBeacons.")
                    .foregroundStyle(Color.red)
            }
            if manager.detectedBeacons.isEmpty {
                Text("Searching for Beacons...")
                    .font(.headline)
                    .padding()
            } else {
                Text("Detected Beacons")
                    .font(.headline)
                    .padding()
            }
            
            ForEach(manager.detectedBeacons) { beacon in
                VStack {
                    Text("UUID: \(beacon.id.uuidString)")
                        .foregroundStyle(Color.green)
                    Text("Proximity: \(beacon.proximity.description)")
                    Text("Distance: \(String(format: "%.2f meters", beacon.distance))")
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
//    BeaconView()
//}
