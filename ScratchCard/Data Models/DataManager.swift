//
//  DataManager.swift
//  ScratchCard
//
//  Created by Ezagor on 16.07.2023.
//

import Foundation
class DataManager {
    static let shared = DataManager()
    
    private var totalMetabytes: Int = 0
    
    private init() {}
    
    func updateMetabytes(amount: Int) {
        totalMetabytes += amount
    }
    
    func getTotalMetabytes() -> Int {
        return totalMetabytes
    }
}

