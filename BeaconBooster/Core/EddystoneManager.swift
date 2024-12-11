//
//  EddystoneManager.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/11/24.
//

import Foundation
import CoreBluetooth
import Combine

/* Manages scanning and detection of Eddystone beacons using Core Bluetooth. */
class EddystoneManager: NSObject, ObservableObject, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager
    private let eddystoneServiceUUID = CBUUID(string: "FEAA")
    
    @Published var detectedBeacons: [Eddystone] = []
    
    override init() {
        centralManager = CBCentralManager(delegate: nil, queue: nil)
        super.init()
        centralManager.delegate = self
    }

    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: [eddystoneServiceUUID], options: nil)
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        }
    }
    
    /* Manages eddystone beacons emitting TLM frames[0x20].
     Adds new beacon to the array or update its values if it exists */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data],
              let eddystoneData = serviceData[eddystoneServiceUUID],
              let frameType = eddystoneData.first, frameType == 0x20 else { return }

        let newBeacon = Eddystone(
            id: peripheral.identifier.uuidString,
            displayName: peripheral.name ?? "Unknown Device",
            distance: RSSI.intValue.distanceFromRSSI()
        )
        
        DispatchQueue.main.async {
            if let index = self.detectedBeacons.firstIndex(where: { $0.id == newBeacon.id }) {
                self.detectedBeacons[index] = newBeacon
            } else {
                self.detectedBeacons.append(newBeacon)
            }
        }
    }
}
