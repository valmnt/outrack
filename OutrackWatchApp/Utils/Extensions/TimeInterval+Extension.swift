//
//  TimeInterval+Extension.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 01/09/2023.
//

import Foundation

extension TimeInterval {
    func formatElapsedTime() -> String {
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
    }
}
