//
//  Item.swift
//  JiraMuraller
//
//  Created by Stacey Vetzal on 2024-09-20.
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
