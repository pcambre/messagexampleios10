//
//  SenderViewController.swift
//  demo
//
//  Created by Pablo Cambre on 9/26/16.
//  Copyright © 2016 Pablo Cambre. All rights reserved.
//

import UIKit

class SenderViewController: UIViewController {
    
    static let storyboardIdentifier = "SenderViewController"
    weak var delegate: SenderViewControllerDelegate?
    
    @IBAction func didTapMessage1(_: AnyObject) {
        delegate?.sendSelectedMessage(self, "Mensaje 1")
    }
    
    @IBAction func didTapMessage2(_: AnyObject) {
        delegate?.sendSelectedMessage(self, "Mensaje 2")
    }
    
}

protocol SenderViewControllerDelegate: class {
    func sendSelectedMessage(_ controller: SenderViewController, _ message: String)
}
