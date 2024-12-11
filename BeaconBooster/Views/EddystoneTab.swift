//
//  EddystoneTab.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/11/24.
//

import SwiftUI

struct EddystoneTab: View {
    @ObservedObject var manager: EddystoneManager
    
    var body: some View {
        VStack {
            if manager.detectedBeacons.isEmpty {
                Text("Searching for Eddystone Beacons...")
                    .font(.headline)
                    .padding()
            } else {
                Text("Detected Eddystone Beacons")
                    .font(.headline)
                    .padding()
            }
            
            List(manager.detectedBeacons) { beacon in
                VStack(alignment: .leading) {
                    Text("Name: \(beacon.displayName)")
                        .foregroundStyle(.green)
                    Text("Distance: \(beacon.distance, specifier: "%.2f") meters")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear { manager.startScanning() }
        .onDisappear { manager.stopScanning() }
    }
}

//#Preview {
//    EddystoneTab()
//}
