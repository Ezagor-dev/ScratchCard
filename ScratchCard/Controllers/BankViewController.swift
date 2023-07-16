//
//  BankViewController.swift
//  ScratchCard
//
//  Created by Ezagor on 16.07.2023.
//

import Foundation
import UIKit

class BankViewController: UIViewController {
    private let metabytesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateMetabytes()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Configure the metabytes label
        metabytesLabel.textAlignment = .center
        metabytesLabel.font = UIFont.systemFont(ofSize: 24)
        metabytesLabel.text = "Total MetaBytes: 0"
        view.addSubview(metabytesLabel)
        // Add constraints or set frame for the metabytesLabel
        
        // Configure navigation bar
        title = "Bank"
    }
    
    private func updateMetabytes() {
        let totalMetabytes = DataManager.shared.getTotalMetabytes()
        metabytesLabel.text = "Total MetaBytes: \(totalMetabytes)"
    }

}
