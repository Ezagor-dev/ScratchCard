//
//  BankViewController.swift
//  ScratchCard
//
//  Created by Ezagor on 16.07.2023.
//

import Foundation
import UIKit

class BankViewController: UIViewController {
    private let bankView = BankView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateMetabyteCount()
    }
    
    private func setupUI() {
        view.addSubview(bankView)
        // Add constraints or set frame for the bankView
        
        // Configure navigation bar
        title = "Bank"
    }
    
    private func updateMetabyteCount() {
        // Fetch the total metabyte count from data source
        let totalMetabytes = DataManager.shared.getTotalMetabyteCount()
        bankView.setMetabyteCount(totalMetabytes)
    }
}
