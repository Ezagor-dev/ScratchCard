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
    private var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
            scratchcardView = ScratchcardView(frame: view.bounds)
            // ...
            scratchcardView.onPlayAgain { [weak self] in
                self?.resetScratchcard()
            }
            view.addSubview(scratchcardView)
        }
    
    
    @objc private func openBank() {
           let bankViewController = BankViewController()
           navigationController?.pushViewController(bankViewController, animated: true)
       }
    
    
    
    @objc private func resetScratchcard() {
        scratchcardView.reset()
        scratchcardView.backgroundColor = UIColor(patternImage: backgroundImage!)
    }



}
