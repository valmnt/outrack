//
//  String+Extension.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 08/09/2023.
//

import Foundation

extension String {
    func replaceCommaByPoint() -> String {
        return self.replacingOccurrences(of: ",", with: ".")
    }
}
