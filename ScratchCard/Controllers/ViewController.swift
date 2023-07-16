//
//  ViewController.swift
//  ScratchCard
//
//  Created by Ezagor on 16.07.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scratchcardView: ScratchcardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupScratchcardView()

    }
    func setupScratchcardView() {
        let scratchcardView = ScratchcardView(frame: view.bounds)
        scratchcardView.backgroundColor = .lightGray
        view.addSubview(scratchcardView)
    }


}


