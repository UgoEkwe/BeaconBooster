//
//  Int+DistanceCalculation.swift
//  BeaconBooster
//
//  Created by Ugonna Oparaochaekwe on 12/11/24.
//

import Foundation

extension Int {
    func distanceFromRSSI(calibratedPower: Int = -45) -> Double {
        guard self != 0 else { return -1.0 }
        let ratio = Double(self) - Double(calibratedPower)
        return pow(10.0, ratio / (-20))
    }
}
