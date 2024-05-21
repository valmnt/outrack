//
//  TimeManager.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 13/09/2023.
//

import Foundation

class TimeManager {
    static func secondsToTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
}
