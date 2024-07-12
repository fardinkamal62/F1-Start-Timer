//
//  Item.swift
//  F1 Start Timer
//
//  Created by Fardin Kamal on 12/7/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
