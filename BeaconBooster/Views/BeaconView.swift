//
//  BeaconView.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/10/24.
//

import SwiftUI

struct BeaconView: View {
    @StateObject private var beaconManager = BeaconManager()
    @StateObject private var eddystoneManager = EddystoneManager()
    
    var body: some View {
        VStack {
            TabView {
                iBeaconTab(manager: beaconManager)
                    .tabItem {
                        Label("iBeacon", systemImage: "dot.radiowaves.left.and.right")
                    }
                EddystoneTab(manager: eddystoneManager)
                    .tabItem {
                        Label("Eddystone", systemImage: "antenna.radiowaves.left.and.right")
                    }
            }
        }
    }
}

//#Preview {
//    BeaconView()
//}
