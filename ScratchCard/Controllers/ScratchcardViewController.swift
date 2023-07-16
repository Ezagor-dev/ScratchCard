//
//  ScratchcardViewController.swift
//  ScratchCard
//
//  Created by Ezagor on 16.07.2023.
//

import Foundation
import UIKit

class ScratchcardViewController: UIViewController {
    private var scratchcardView: ScratchcardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        scratchcardView = ScratchcardView(frame: view.bounds)
        view.addSubview(scratchcardView)
    }
    @objc private func openBank() {
           let bankViewController = BankViewController()
           navigationController?.pushViewController(bankViewController, animated: true)
       }
}
