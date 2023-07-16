//
//  DataManager.swift
//  ScratchCard
//
//  Created by Ezagor on 16.07.2023.
//

import Foundation
class DataManager {
    static let shared = DataManager()
    
    private var metabyteCount: Int = 0
    
    private init() {
        // Initialize any necessary data or perform setup
    }
    
    func addMetabytes(amount: Int) {
        metabyteCount += amount
        // Perform necessary data persistence operations
    }
    
    func getTotalMetabyteCount() -> Int {
        return metabyteCount
    }
}
