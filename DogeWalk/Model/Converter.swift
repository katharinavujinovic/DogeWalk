//
//  Converter.swift
//  DogeWalk
//
//  Created by Katharina Müllek on 07.05.21.
//

import Foundation

class Converter {
    
    func displayTime(seconds:Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds: seconds)
      return ("\(h):\(m):\(s)")
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func displayDistance(meter: Double) -> String {
        if UserDefaults.standard.bool(forKey: "metricSelected") {
            return kmFromMeter(meter: meter)
        } else {
            return milesFromMeter(meter: meter)
        }
    }
    
    func kmFromMeter(meter: Double) -> String {
        let kmCount = meter/1000
        let kmCountString = String(format: "%.2f", kmCount)
        return "\(kmCountString) km"
    }
    
    func milesFromMeter(meter: Double) -> String {
        let mileCount = meter * 0.000621371
        let mileCountString = String(format: "%.2f", mileCount)
        return "\(mileCountString) mi"
    }
}
