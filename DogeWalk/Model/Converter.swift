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
    
    func timeFormatter(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .short
        timeFormatter.timeStyle = .none
        let dateString = timeFormatter.string(from: date)
        return dateString
    }
    
    func startTime(date: Date) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        let startingTime = timeFormatter.string(from: date)
        return startingTime
    }
    
    func birthDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func yearsBetweenDate(startDate: Date, endDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: startDate, to: endDate)
        if components.year == 0 {
            let months = calendar.dateComponents([.month], from: startDate, to: endDate)
            return String(describing: months.month)
        } else {
            return String(describing: components.year)
        }
    }
    
}
